/**
 * 判断字符是否为空的方法
 * */
function isEmpty(obj){
    if(typeof obj == "undefined" || obj == null || obj == ""){
        return true;
    }else{
        return false;
    }
}

/**
 * 输入 key 获取 value
 * */
function getDicValue(lst_dic_json, key) {
    for (var i = 0; i < lst_dic_json.length; i++)
    {
        var dic = lst_dic_json[i];
        if (dic['key'] == key)
        {
            return dic['value'];
        }
    }
    return '';
}

/**
 * 输入 value 获取 key
 * */
function getDicKey(lst_dic_json, value) {
    for (var i = 0; i < lst_dic_json.length; i++)
    {
        var dic = lst_dic_json[i];
        if (dic['value'] == value)
        {
            return dic['key'];
        }
    }
    return '';
}

/**
 * 判断是否有 key
 * */
function exist_key(json, key) {
    for (var k in json)
    {
        if (k == key)
        {
            return true;
        }
    }
    return false;
}


function column_boolean(value, metaData, record, rowIndex, colIndex, store) {
    if (value == true || 1 == parseInt(value))
    {
        return '是';
    }
    return '否';
}

function column_date(value, metaData, record, rowIndex, colIndex, store) {
    return Ext.util.Format.dateRenderer('Y-m-d');
}

/**
 * 判断是否有查询项
 * */
function is_query_field(field, json_fields) {
    if (isEmpty(field) && isEmpty(json_fields))
    {
        for (var i = 0; i < json_fields.length; i++)
        {
            var f = json_fields[i];
            if (field['fieldLabel'] == f['cn_name'] && field['name'] == f['en_name'] && f['query'] == true)
            {
                return field;
            }
        }
    }
    return null;
}

/**
 * 类的描述
 * 1、构造一个 ms = [{'scenes_name': '', 'input_paras': input_parameter_context, 'nodes': nodes, 'expire': '创建时间'}]
 * input_parameter_context: [{'index': 0, 'parameter_name': '', 'parameter_type': '', 'parameter_java_type': '', 'parameter_value': ''}]
 * nodes: [{'id': '', 'x': '', 'y': '', 'seq_name': '', 'sql': '', 'is_run': 0}]
 *
 * 2、新增 scenes
 *
 * 3、修改 scenes
 *
 * 4、过期 scenes
 * */
function myLocalStore()
{
    this.localStore = new Ext.state.LocalStorageProvider();
    // ms = [{'scenes_name': '', 'input_paras': input_parameter_context, 'nodes': nodes, 'expire': '创建时间'}]
    this.ms = [];
    if (this.localStore.get('my_scenes') == null) {
        this.localStore.set('my_scenes', this.localStore.encodeValue(this.ms));
    }
    else
    {
        this.ms = this.localStore.decodeValue(this.localStore.get('my_scenes'));
    }

    this.create_scene = function (scenes_name) {
        if (this.getValue(scenes_name) == null)
        {
            this.setValue({'scenes_name': scenes_name, 'input_paras': [], 'nodes': [], 'expire': new Date()});
        }
    }

    // 更新 store
    this.update_input_paras = function (scenes_name, input_paras) {
        var scenes_vs = this.getValue(scenes_name);
        if (scenes_vs != null)
        {
            scenes_vs.input_paras = input_paras;
            this.setValue(scenes_vs);
        }
    };

    this.getValue = function (scenes_name) {
        this.expire_del();
        if (this.ms.length > 0)
        {
            for (var i = 0; i < this.ms.length; i++)
            {
                if (this.ms[i]['scenes_name'] == scenes_name)
                {
                    return this.ms[i];
                }
            }
        }
        return null;
    };

    this.setValue = function (scenes_value = {}) {
        this.expire_del();
        var scenes_name = null;

        if (exist_key(scenes_value, 'scenes_name') && scenes_value['scenes_name'] != '') {
            scenes_name = scenes_value['scenes_name'];
            var vs = this.getValue(scenes_name);
            if (vs == null) {
                this.ms.push(scenes_value);
                this.localStore.set('my_scenes', this.localStore.encodeValue(this.ms));
            } else {
                if (this.ms.length > 0) {
                    for (var i = 0; i < this.ms.length; i++) {
                        if (this.ms[i]['scenes_name'] == scenes_name) {
                            this.ms = Ext.Array.replace(this.ms, i, 1, [scenes_value]);
                            this.localStore.set('my_scenes', this.localStore.encodeValue(this.ms));
                        }
                    }
                }
            }
        }
    };

    /**
     * scenes_name: 场景名称
     * seq_name： 序列名称
     * 返回：seq_obj
     * */
    this.findSql_node = function (scenes_name, seq_name) {
        var scenes_json = this.getValue(scenes_name);
        if (scenes_json != null && scenes_json.nodes.length > 0)
        {
            for (var i = 0; i < scenes_json.nodes.length; i++)
            {
                if (seq_name == scenes_json.nodes[i]['seq_name'])
                {
                    return scenes_json.nodes[i];
                }
            }
        }
        return null;
    };

    /**
     * scenes_name: 场景名称
     * seq_name： 序列名称
     * 返回：sql 字符串
     * */
    this.findSql = function (scenes_name, seq_name) {
        var sql_node = this.findSql_node(scenes_name, seq_name);
        if (sql_node != null)
        {
            return sql_node['sql'];
        }
        return null;
    };

     /**
      * update sql obj
      * scenes_name: 场景名称
      * seq_name： 序列名称
      * 返回：sql 字符串
      * */
     this.updateNode = function (scenes_name, node) {
         var sql_node = this.findSql_node(scenes_name, node['seq_name']);
        if (sql_node != null)
        {
            sql_node['sql'] = node.sql;
            this.localStore.set('my_scenes', this.localStore.encodeValue(this.ms));
        }
        else
        {
            this.insertNode(scenes_name, node);
        }
     };

     /**
      * insert sql obj
      * scenes_name: 场景名称
      * seq_name： 序列名称
      * 返回：sql 字符串
      * */
     this.insertNode = function (scenes_name, node) {
         var scenes_json = this.getValue(scenes_name);
         if (scenes_json != null) {
             Ext.Array.push(scenes_json.nodes, node);
             this.localStore.set('my_scenes', this.localStore.encodeValue(this.ms));
         }
     }

     /**
      * delete sql obj
      * scenes_name: 场景名称
      * seq_name： 序列名称
      * */
     this.deleteNode = function (scenes_name, node) {
         var scenes_json = this.getValue(scenes_name);
         if (scenes_json != null) {
             Ext.Array.remove(scenes_json.nodes, node);
             this.localStore.set('my_scenes', this.localStore.encodeValue(this.ms));
         }
     }

    /**
     * 过期清除
     * */
    this.expire_del = function () {
        if (this.ms.length > 0)
        {
            var my_date = new Date();
            var now_date = new Date();
            for (var i = 0; i < this.ms.length; i++)
            {
                my_date.setTime(Date.parse(this.ms[i]['expire']) + (1000 * 3600 * 24 * 20))
                if (my_date.getTime() < now_date.getTime())
                {
                    this.ms = Ext.Array.remove(this.ms, this.ms[i]);
                    this.localStore.set('my_scenes', this.localStore.encodeValue(this.ms));
                }
            }
        }
    };
}

Ext.define('cn.plus.ComboStore', {
    extend: 'Ext.data.JsonStore',
    remoteSort: true,
    fields: ['v', 'txt'],
    constructor: function (config) {
        config = Ext.apply({
            proxy: {
                type: 'ajax',
                //url: '/admin/query_table_template/',
                url: config.url,
                reader: {
                    type: 'json',
                    root: "root"
                }
            }
        }, config);
        this.callParent([config]);
    }
});

Ext.define('cn.plus.GoogleSuggest', {
    extend: 'Ext.form.ComboBox',
    cls: 'txt_right',
    hiddenName: 'v',
    displayField: 'txt',
    valueField: 'v',
    queryParam: 'v',
    forceSelection: false,
    hideTrigger: true,
    queryDelay: 250,
    enableKeyEvents: true,
    minChars: 1,
    mode: 'remote',
    initComponent: function () {
        var me = this;

        me.store = Ext.create('cn.plus.ComboStore', {
            url: me.url
        });

        this.callParent();
    }
});

var my_win = function (table_name) {
    var win_store = new Ext.data.JsonStore({
        proxy: {
            type: 'ajax',
            url: '/suggest/table_details/',
            //actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'},
            reader: {
                type: 'json',
                root: "root",
                totalProperty: "totalProperty"
            }
        },
        //remoteSort: true,
        fields: ['column_name', 'column_type', 'pkid', 'comments'],
        sorters: [{
            property: 'column_name',
            direction: 'ASC'
        }]
    });
    var win = Ext.create('Ext.window.Window', {
        title: '表(' + table_name + ')详情',
        width: 486,
        height: 371,
        resizable: true,
        closeAction: 'hide',
        closable: true,
        bodyStyle: 'overflow-x:hidden;overflow-y:scroll',
        border: true,
        hidden: true,
        items: [Ext.create('Ext.grid.Panel', {
            columns: [{
                text: '列名',
                dataIndex: 'column_name',
                sortable: false
            }, {
                text: '列数据类型',
                dataIndex: 'column_type',
                sortable: false
            }, {
                text: '是否是主键',
                dataIndex: 'pkid',
                sortable: false,
                renderer: function (value, metaData, record, rowIndex, colIndex, store) {
                    if (value == false) {
                        return '否';
                    }
                    return '是';
                }
            }, {
                text: '注释',
                dataIndex: 'comments',
                sortable: false
            }],
            store: win_store
        })]
    });

    win_store.load({
        params: {
            table_name: table_name
        }
    });
    win.show();
};

Ext.define('cn.plus.tableWin', {
    extend: 'Ext.window.Window',
    height: 344,
    width: 621,
    initComponent: function () {
        var me = this;

        var store = new Ext.data.JsonStore({
            proxy: {
                type: 'ajax',
                url: '/suggest/all_table/',
                //actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'},
                reader: {
                    type: 'json',
                    root: "root",
                    totalProperty: "totalProperty"
                }
            },
            remoteSort: true,
            fields: ['table_name', 'descrip'],
            sorters: [{
                property: 'table_name',
                direction: 'ASC'
            }]
        });

        var tbar = Ext.create('Ext.toolbar.Toolbar', {
            enableOverflow: true,
            items: [{
                xtype: 'tbspacer'
            }, Ext.create('cn.plus.GoogleSuggest', {
                url: '/suggest/suggest_tablename/',
                id: 'table_name',
                name: 'table_name',
                emptyText: '输入要查询的表名'
            }), {
                xtype: 'tbspacer'
            }, {
                text: '查询',
                handler: function () {
                    store.load({
                        params: {
                            table_name: Ext.getCmp('table_name').getValue(),
                            start: 0,
                            limit: bbar.pageSize
                        }
                    });
                }
            }]
        });

        var pagesize_combo = new Ext.form.ComboBox({
            triggerAction: 'all',
            mode: 'local',
            store: new Ext.data.ArrayStore({
                fields: ['value', 'text'],
                data: [[50, '50条/页'], [100, '100条/页'], [250, '250条/页'], [500, '500条/页']]
            }),
            valueField: 'value',
            displayField: 'text',
            value: 50,
            editable: false,
            width: 85
        });

        var number = parseInt(pagesize_combo.getValue());
        // 改变每页显示条数reload数据
        pagesize_combo.on("select", function (comboBox) {
            bbar.pageSize = parseInt(comboBox.getValue());
            number = parseInt(comboBox.getValue());
            me.getStore().reload({
                params: {
                    start: 0,
                    limit: bbar.pageSize
                }
            });
        });

        // 分页工具栏
        var bbar = new Ext.PagingToolbar({
            pageSize: number,
            store: store,
            displayInfo: true,
            displayMsg: '当前记录 {0} -- {1} 条 共 {2} 条记录',
            prevText: "上一页",
            nextText: "下一页",
            refreshText: "刷新",
            lastText: "最后页",
            firstText: "第一页",
            beforePageText: "当前页",
            afterPageText: "共{0}页",
            emptyMsg: "没有符合条件的记录",
            items: ['-', '&nbsp;&nbsp;', pagesize_combo]
        });

        var grid = new Ext.grid.GridPanel({
            autoHeight: true,
            stripeRows: true,
            store: store,
            columns: [{
                text: '表名',
                dataIndex: 'table_name',
                sortable: true,
                tooltip: '表名',
                renderer: function (value, metaData, record, rowIndex, colIndex, store) {
                    return '<a href="javascript:my_win(\'' + value + '\');">' + value + '</a>';
                }
            }, {text: '描述', dataIndex: 'descrip', sortable: true, tooltip: '描述'}],
            autoScroll: true,
            border: true,
            viewConfig: {
                columnsText: "显示/隐藏列",
                sortAscText: "正序排列",
                sortDescText: "倒序排列",
                forceFit: true
            },
            loadMask: {
                msg: '正在加载数据，请稍等．．．'
            },
            bbar: bbar,
            listeners: {
                'contextmenu': function (e) {
                    e.stopEvent();
                }
            }
        });

        store.on('beforeload', function (store) {
            var table_name_txt = Ext.getCmp('table_name');
            Ext.apply(store.proxy.extraParams, {
                table_name: table_name_txt.getValue()
            });

        });

        store.load({
            params: {
                table_name: Ext.getCmp('table_name').getValue(),
                start: 0,
                limit: bbar.pageSize
            }
        });

        Ext.apply(this, {
            tbar: tbar,
            items: [grid]
        });

        this.callParent();
    }
});

Ext.define('cn.plus.sugest_tree', {
    extend: 'Ext.tree.Panel',
    listeners: {
        "itemclick": function (me, record, item, index, e, eOpts) {
            if (index == 0)
            {
                var table_win = Ext.create('cn.plus.tableWin', {
                    title: '表',
                    closeAction: "hide",
                    hidden: true,
                    layout: 'fit',
                    maximizable: true
                });
                table_win.show();
            }
        }
    },
    rootVisible: false,
    initComponent: function () {

        var store = Ext.create('Ext.data.TreeStore', {
            root: {
                expanded: true,
                children: [{
                    text: '<a href="#">表(table)</a>',
                    leaf: true
                }, {
                    text: '<a target="_blank" href="/suggest/func_win/">扩展方法</a>',
                    leaf: true
                }, {
                    text: '<a target="_blank" href="/suggest/authority_win/">权限 view</a>',
                    leaf: true
                }, {
                    text: '<a target="_blank" href="/suggest/scenes_win/">场景</a>',
                    leaf: true
                }]
            }
        });

        var base_config = {
            store: store
        };

        Ext.apply(this, base_config);
        this.callParent();
    }
});























































