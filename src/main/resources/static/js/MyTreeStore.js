/**
 * Ext.create('cn.grid.TreeStore', {
 *			model: 'myModel',
 *			storeId: 'MyTreeModel',
 * 			proxy: {
 *				type: 'ajax',
 * 				url: 'url.do',
 *				reader: {
 *					type: 'json',
 *					root: 'myTree',
 *					totalProperty: 'totalProperty'	// 一定需要这个参数接受后台返回的总条数
 *				}
 *			},
 *			root: {
 *				id: 0,
 *				text: 'root',
 *				expanded: true
 *			}
 *		})
 * */

Ext.define('cn.grid.TreeStore', {
	extend: 'Ext.data.TreeStore',
	alias: 'store.MyTreeStore',

	/**
	 * 每页显示条数
	 *
	 */
	pageSize: 50,

	/**
	 * 当前页 默认为第一页
	 *
	 */
	currentPage: 1,

	purgePageCount: 5,

	defaultPageSize: 25,

	/**
	 * 构造函数
	 *
	 */
	constructor: function(config) {
        var me = this,
            root,
            fields,
            defaultRoot,
			data,
			proxy;

        config = Ext.apply({}, config);

		/**
         * @event prefetch
         * Fires whenever records have been prefetched
         * @param {Ext.data.Store} this
         * @param {Ext.data.Model[]} records An array of records.
         * @param {Boolean} successful True if the operation was successful.
         * @param {Ext.data.Operation} operation The associated operation
         */
        data = config.data || me.data;

        /**
         * @property {Ext.util.MixedCollection} data
         * The MixedCollection that holds this store's local cache of records.
         */
        me.data = new Ext.util.MixedCollection(false, Ext.data.Store.recordIdFn);

		if (data) {
            me.inlineData = data;
            delete config.data;
        }


        /**
         * If we have no fields declare for the store, add some defaults.
         * These will be ignored if a model is explicitly specified.
         */
        fields = config.fields || me.fields;
        if (!fields) {
            config.fields = [
                {name: 'text', type: 'string'}
            ];
            defaultRoot = config.defaultRootProperty || me.defaultRootProperty;
            if (defaultRoot !== me.defaultRootProperty) {
                config.fields.push({
                    name: defaultRoot,
                    type: 'auto',
                    defaultValue: null,
                    persist: false
                });
            }
        }

        me.callParent([config]);

		/**
		 * @property {Ext.data.Store.PageMap} pageMap
		 * Internal PageMap instance.
		 * @private
		 */
		me.pageMap = new me.PageMap({
			pageSize: me.pageSize,
			maxSize: me.purgePageCount,
			listeners: {
				// Whenever PageMap gets cleared, it means we re no longer interested in
				// any outstanding page prefetches, so cancel tham all
				clear: me.cancelAllPrefetches,
				scope: me
			}
		});
		me.pageRequests = {};
		me.sortOnLoad = false;
		me.filterOnLoad = false;

		proxy = me.proxy;
        data = me.inlineData;

		if (data) {
            if (proxy instanceof Ext.data.proxy.Memory) {
                proxy.data = data;
                me.read();
            } else {
                me.add.apply(me, [data]);
            }

            me.sort();
            delete me.inlineData;
        } else if (me.autoLoad) {
            Ext.defer(me.load, 10, me, [ typeof me.autoLoad === 'object' ? me.autoLoad : undefined ]);
            // Remove the defer call, we may need reinstate this at some point, but currently it's not obvious why it's here.
            // this.load(typeof this.autoLoad == 'object' ? this.autoLoad : undefined);
        }

        // We create our data tree.
        me.tree = new Ext.data.Tree();

        me.relayEvents(me.tree, [
            /**
             * @event append
             * @inheritdoc Ext.data.Tree#append
             */
            "append",

            /**
             * @event remove
             * @inheritdoc Ext.data.Tree#remove
             */
            "remove",

            /**
             * @event move
             * @inheritdoc Ext.data.Tree#move
             */
            "move",

            /**
             * @event insert
             * @inheritdoc Ext.data.Tree#insert
             */
            "insert",

            /**
             * @event beforeappend
             * @inheritdoc Ext.data.Tree#beforeappend
             */
            "beforeappend",

            /**
             * @event beforeremove
             * @inheritdoc Ext.data.Tree#beforeremove
             */
            "beforeremove",

            /**
             * @event beforemove
             * @inheritdoc Ext.data.Tree#beforemove
             */
            "beforemove",

            /**
             * @event beforeinsert
             * @inheritdoc Ext.data.Tree#beforeinsert
             */
            "beforeinsert",

            /**
             * @event expand
             * @inheritdoc Ext.data.Tree#expand
             */
            "expand",

            /**
             * @event collapse
             * @inheritdoc Ext.data.Tree#collapse
             */
            "collapse",

            /**
             * @event beforeexpand
             * @inheritdoc Ext.data.Tree#beforeexpand
             */
            "beforeexpand",

            /**
             * @event beforecollapse
             * @inheritdoc Ext.data.Tree#beforecollapse
             */
            "beforecollapse",

            /**
             * @event sort
             * @inheritdoc Ext.data.Tree#sort
             */
            "sort",

            /**
             * @event rootchange
             * @inheritdoc Ext.data.Tree#rootchange
             */
            "rootchange"
        ]);

        me.tree.on({
            scope: me,
            remove: me.onNodeRemove,
            // this event must follow the relay to beforeitemexpand to allow users to
            // cancel the expand:
            beforeexpand: me.onBeforeNodeExpand,
            beforecollapse: me.onBeforeNodeCollapse,
            append: me.onNodeAdded,
            insert: me.onNodeAdded,
            sort: me.onNodeSort
        });

        me.onBeforeSort();

        root = me.root;
        if (root) {
            delete me.root;
            me.setRootNode(root);
        }

        //<deprecated since=0.99>
        if (Ext.isDefined(me.nodeParameter)) {
            if (Ext.isDefined(Ext.global.console)) {
                Ext.global.console.warn('Ext.data.TreeStore: nodeParameter has been deprecated. Please use nodeParam instead.');
            }
            me.nodeParam = me.nodeParameter;
            delete me.nodeParameter;
        }
        //</deprecated>
    },

	/**
     * Loads the Store using its configured {@link #proxy}.
     * @param {Object} options (Optional) config object. This is passed into the {@link Ext.data.Operation Operation}
     * object that is created and then sent to the proxy's {@link Ext.data.proxy.Proxy#read} function.
     * The options can also contain a node, which indicates which node is to be loaded. If not specified, it will
     * default to the root node.
     */
    load: function(options) {
        options = options || {};
        options.params = options.params || {};

        var me = this,
            node = options.node || me.tree.getRootNode();

		options.page = options.page || me.currentPage;
        options.start = (options.start !== undefined) ? options.start : (options.page - 1) * me.pageSize;
        options.limit = options.limit || me.pageSize;

        // If there is not a node it means the user hasnt defined a rootnode yet. In this case lets just
        // create one for them.
        if (!node) {
            node = me.setRootNode({
                expanded: true
            }, true);
        }

        // Assign the ID of the Operation so that a REST proxy can create the correct URL
        options.id = node.getId();

        if (me.clearOnLoad) {
            if(me.clearRemovedOnLoad) {
                // clear from the removed array any nodes that were descendants of the node being reloaded so that they do not get saved on next sync.
                me.clearRemoved(node);
            }
            // temporarily remove the onNodeRemove event listener so that when removeAll is called, the removed nodes do not get added to the removed array
            me.tree.un('remove', me.onNodeRemove, me);
            // remove all the nodes
            node.removeAll(false);
            // reattach the onNodeRemove listener
            me.tree.on('remove', me.onNodeRemove, me);
        }

        Ext.applyIf(options, {
            node: node
        });
        options.params[me.nodeParam] = node ? node.getId() : 'root';

        if (node) {
            node.set('loading', true);
        }

        return me.callParent([options]);
    },

	// inherit docs
    onProxyLoad: function(operation) {
        var me = this,
            successful = operation.wasSuccessful(),
            records = operation.getRecords(),
            node = operation.node,
			resultSet = operation.getResultSet();

		if (resultSet) {
			me.totalCount = resultSet.total;
		}

		me.mycount = resultSet.count;

        me.loading = false;
        node.set('loading', false);
        if (successful) {
            if (!me.clearOnLoad) {
                records = me.cleanRecords(node, records);
            }
            records = me.fillNode(node, records);
        }
        // The load event has an extra node parameter
        // (differing from the load event described in AbstractStore)
        /**
         * @event load
         * Fires whenever the store reads data from a remote data source.
         * @param {Ext.data.TreeStore} this
         * @param {Ext.data.NodeInterface} node The node that was loaded.
         * @param {Ext.data.Model[]} records An array of records.
         * @param {Boolean} successful True if the operation was successful.
         */
        // deprecate read?
        me.fireEvent('read', me, operation.node, records, successful);
        me.fireEvent('load', me, operation.node, records, successful);
        //this is a callback that would have been passed to the 'read' function and is optional
        Ext.callback(operation.callback, operation.scope || me, [records, operation, successful]);
    },

	/**
	 * 获取总条数
	 *
	 */
	getTotalCount: function() {
        return this.totalCount || 0;
    },

	/**
	 * 获取当前 data 中条目数
	 *
	 */
	getCount: function () {
		return this.mycount || 0;
	},

	/**
     * Loads a given 'page' of data by setting the start and limit values appropriately. Internally this just causes a normal
     * load operation, passing in calculated 'start' and 'limit' params
     * @param {Number} page The number of the page to load
     * @param {Object} options See options for {@link #method-load}
     */
	loadPage: function(page, options) {
        var me = this;

        me.currentPage = page;

        // Copy options into a new object so as not to mutate passed in objects
        options = Ext.apply({
            page: page,
            start: (page - 1) * me.pageSize,
            limit: me.pageSize,
            addRecords: !me.clearOnPageLoad
        }, options);

        if (me.buffered) {
            return me.loadToPrefetch(options);
        }
        me.read(options);
    },

	/**
     * Loads the next 'page' in the current data set
     * @param {Object} options See options for {@link #method-load}
     */
    nextPage: function(options) {
        this.loadPage(this.currentPage + 1, options);
    },

    /**
     * Loads the previous 'page' in the current data set
     * @param {Object} options See options for {@link #method-load}
     */
    previousPage: function(options) {
        this.loadPage(this.currentPage - 1, options);
    },

	/**
     * @private
     * Cancels all pending prefetch requests.
     *
     * This is called when the page map is cleared.
     *
     * Any requests which still make it through will be for the previous page map generation
     * (generation is incremented upon clear), and so will be rejected upon arrival.
     */
    cancelAllPrefetches: function() {
        var me = this,
            reqs = me.pageRequests,
            req,
            page;

        // If any requests return, we no longer respond to them.
        if (me.pageMap.events.pageadded) {
            me.pageMap.events.pageadded.clearListeners();
        }

        // Cancel all outstanding requests
        for (page in reqs) {
            if (reqs.hasOwnProperty(page)) {
                req = reqs[page];
                delete reqs[page];
                delete req.callback;
            }
        }
    },

	/**
	 * 根据树JSON 中id 获取对应NODE
	 *
	 * 此方法会调用Ext.data.Tree中的getNodeById
	 *
	 */
	getNodeById: function (id) {
		return this.tree.getNodeById(id);
	}

}, function() {
    var proto = this.prototype;
    proto.indexSorter = new Ext.util.Sorter({
        sorterFn: proto.sortByIndex
    });

    /**
     * @class Ext.data.Store.PageMap
     * @extends Ext.util.LruCache
     * Private class for use by only Store when configured `buffered: true`.
     * @private
     */
    this.prototype.PageMap = new Ext.Class({
        extend: 'Ext.util.LruCache',

        // Maintain a generation counter, so that the Store can reject incoming pages destined for the previous generation
        clear: function(initial) {
            this.generation = (this.generation ||0) + 1;
            this.callParent(arguments);
        },

        getPageFromRecordIndex: this.prototype.getPageFromRecordIndex,

        addPage: function(page, records) {
            this.add(page, records);
            this.fireEvent('pageAdded', page, records);
        },

        getPage: function(page) {
            return this.get(page);
        },

        hasRange: function(start, end) {
            var page = this.getPageFromRecordIndex(start),
                endPage = this.getPageFromRecordIndex(end);

            for (; page <= endPage; page++) {
                if (!this.hasPage(page)) {
                    return false;
                }
            }
            return true;
        },

        hasPage: function(page) {
            // We must use this.get to trigger an access so that the page which is checked for presence is not eligible for pruning
            return !!this.get(page);
        },

        getRange: function(start, end) {
            if (!this.hasRange(start, end)) {
                Ext.Error.raise('PageMap asked for range which it does not have');
            }
            var me = this,
                startPage = me.getPageFromRecordIndex(start),
                endPage = me.getPageFromRecordIndex(end),
                dataStart = (startPage - 1) * me.pageSize,
                dataEnd = (endPage * me.pageSize) - 1,
                page = startPage,
                result = [],
                sliceBegin, sliceEnd, doSlice,
                i = 0, len;

            for (; page <= endPage; page++) {

                // First and last pages will need slicing to cut into the actual wanted records
                if (page == startPage) {
                    sliceBegin = start - dataStart;
                    doSlice = true;
                } else {
                    sliceBegin = 0;
                    doSlice = false;
                }
                if (page == endPage) {
                    sliceEnd = me.pageSize - (dataEnd - end);
                    doSlice = true;
                }

                // First and last pages will need slicing
                if (doSlice) {
                    Ext.Array.push(result, Ext.Array.slice(me.getPage(page), sliceBegin, sliceEnd));
                } else {
                    Ext.Array.push(result, me.getPage(page));
                }
            }

            // Inject the dataset ordinal position into the record as the index
            for (len = result.length; i < len; i++) {
                result[i].index = start++;
            }
            return result;
        }
    });
});