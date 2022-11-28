<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DawnSql编辑器</title>
    <link href="../js/resources/ext-theme-neptune/ext-theme-neptune-all.css" rel="stylesheet"/>
    <script src="../js/ext-all.js" type="text/javascript"></script>
    <script src="../js/locale/ext-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../js/MyVTypes.js" type="text/javascript"></script>
    <script src="../js/utils.js" type="text/javascript"></script>

    <link href="../codemirror/lib/codemirror.css" rel="stylesheet"/>
    <link href="../codemirror/addon/hint/show-hint.css" rel="stylesheet"/>
    <link href="../codemirror/theme/idea.css" rel="stylesheet"/>

    <script src="../codemirror/lib/codemirror.js" type="text/javascript"></script>
    <script src="../codemirror/mode/sql/sql.js" type="text/javascript"></script>
    <script src="../codemirror/addon/hint/show-hint.js" type="text/javascript"></script>
    <script src="../codemirror/addon/hint/sql-hint.js" type="text/javascript"></script>
    <script src="../codemirror/addon/selection/active-line.js" type="text/javascript"></script>

    <style type="text/css">
        .indexicon {
            background-image: url(../page_img/application_home.png) !important;
        }
        .applicationIcon {
            background-image:url(../page_img/application_home.png) !important;
         }

        .application_doubleIcon {
            background-image:url(../page_img/application_double.png) !important;
         }

        .application_cascadeIcon {
            background-image:url(../page_img/application_cascade.png) !important;
         }

        .tbar_synchronizeIcon {
            background-image:url(../page_img/tbar_synchronize.png) !important;
         }

        .t1{
		background-color:#ebf7ff; width:115px; border-bottom:1px solid #b5e2ff; border-right:1px solid #b5e2ff;
		font-size: 12px;
		}
		.t2{
		width:200px; border-bottom:1px solid #b5e2ff; border-right:1px solid #b5e2ff;
		font-size: 12px;
		}
    </style>

    <script type="text/javascript">
        function first(vs) {
                if (vs.length > 0)
                {
                    return vs[0];
                }
                return null;
            }

            function rest(vs) {
                return vs.slice(1);
            }

            function eliminate_comment(vs, lst, lst_0, rs)
            {
                var f = first(vs);
                if (f != null) {
                    var r = rest(vs);
                    if (f == '-' && first(r) == '-' && lst_0.length == 0) {
                        lst.push(1);
                        eliminate_comment(rest(r), lst, lst_0, rs);
                    }
                    else if (f == '\n')
                    {
                        lst.pop();
                        eliminate_comment(r, lst, lst_0, rs);
                    }
                    else if (lst.length > 0)
                    {
                        eliminate_comment(r, lst, lst_0, rs);
                    }
                    else if (f == '/' && first(r) == '*' && lst.length == 0) {
                        lst_0.push(1);
                        eliminate_comment(rest(r), lst, lst_0, rs);
                    }
                    else if (f == '*' && first(r) == '/')
                    {
                        lst_0.pop();
                        eliminate_comment(rest(r), lst, lst_0, rs);
                    }
                    else if (lst_0.length > 0)
                    {
                        eliminate_comment(r, lst, lst_0, rs);
                    }
                    else if (lst_0.length == 0 && lst.length == 0)
                    {
                        rs.push(f);
                        eliminate_comment(r, lst, lst_0, rs);
                    }
                }

                return rs;
            }

            function my_comment(vs)
            {
                return eliminate_comment(vs, [], [], []);
            }

            function has_semicolon(vs)
            {
                var lst = [];
                var flag = null;
                for (var i = 0; i < vs.length; i++)
                {
                    if (vs[i] == '"' && (flag == null || flag == '大'))
                    {
                        if (flag == null)
                        {
                            flag = '大';
                        }

                        if (lst.length > 0)
                        {
                            lst.pop();
                            if (lst.length == 0)
                            {
                                flag = null;
                            }
                        }
                        else
                        {
                            lst.push(i);
                        }
                    }
                    else if (vs[i] == "'" && (flag == null || flag == '小'))
                    {
                        if (flag == null)
                        {
                            flag = '小';
                        }

                        if (lst.length > 0)
                        {
                            lst.pop();
                            if (lst.length == 0)
                            {
                                flag = null;
                            }
                        }
                        else
                        {
                            lst.push(i);
                        }
                    }
                    else if (vs[i] == ';' && flag == null && i < vs.length - 1)
                    {
                        return false;
                    }
                }

                if (flag != null)
                {
                    return '字符串有错误！';
                }
                return true;
            }

            function my_single_select(line)
            {
                var vs = my_comment(Array.from(line));
                if (has_semicolon(vs))
                {
                    var sql = Ext.String.trim(vs.join(''));
                    if (sql.match(/^select\s+/i) != null)
                    {
                        return true;
                    }
                }
                return false;
            }
    </script>

    <script type="text/javascript">
        // 解决Iframe IE加载不完全的问题
        function endIeStatus() { }
        var ShowWin;

        //var my_localStore = new Ext.state.LocalStorageProvider();
        var storage = window.localStorage;

        Ext.application({
            name: 'MyEdit',
            launch: function() {

                var editor;

                /**
                * 生成一个 textarea
                * */
               Ext.DomHelper.append(document.body, {tag: 'textarea', id: 'code_area'});

               Ext.getCmp('code_area');

               var code_area_panel = Ext.create('Ext.panel.Panel', {
                   anchor: '100%',
                   resizable: {
                       handles: 's'
                   },
                   listeners: {
                       resize: function(obj, width, height, oldWidth, oldHeight, eOpts){
                           if (typeof(editor) != 'undefined' && editor)
                           {
                               editor.setSize('auto', height + 'px');
                           }
                       }
                   },
                   contentEl: 'code_area'
               });

               var source = {"users": ["id", "name"], "dbs": ["id", "name"]};
               //var source = eval('(' + document.getElementById('table_info').innerText + ')');

                var edit_form = Ext.create('Ext.form.Panel', {
                   /**
                    * 定义 eidt form
                    * */
                   id: 'edit_form',
                   itemId: 'edite_win',
                   layout: "form",
                   defaults: {
                       anchor: '100%'
                   },
                   buttonAlign: "center",
                   labelAlign: "right",
                   items: [code_area_panel, {
                       id: 'p_grid',
                       itemId: 'p_grid',
                       bodyStyle :'overflow-x:hidden;overflow-y:scroll',
                       border: true,
                       hidden: true
                   }, {
                       itemId: 'p_error',
                       hidden: true
                   }],
                   listeners: {
                       "afterrender": function (m) {
                       }
                   }
               });

                // 右导航
               var tbar = Ext.create('Ext.toolbar.Toolbar', {
                   enableOverflow: true,
                   items: [{
                       text: '运行',
                       handler: function () {
                           var vs = Ext.String.trim(editor.getSelection());
                           if (vs == '') {
                               vs = Ext.String.trim(editor.getValue());
                           }

                           if (vs == '')
                           {
                               return;
                           }

                           if (my_single_select(vs))
                           {
                               var store_url = '/run_select_sql/?user_token=${ m.user_token }';
                               Ext.Msg.wait('正在运行，请稍候...', '信息提示');
                               Ext.Ajax.request({
                                   url: '/run_sql/',
                                   method: 'POST',
                                   params: {
                                       user_token: '${ m.user_token }',
                                       select: 1,
                                       code: vs
                                   },
                                   success: function (response) {
                                       Ext.Msg.hide();
                                       var result = Ext.decode(response.responseText);
                                       var store = new Ext.data.JsonStore({
                                            proxy:{
                                                type: 'ajax',
                                                url: store_url,
                                                actionMethods: {
                                                    read: 'POST'
                                                },
                                                reader: {
                                                    type: 'json',
                                                    root: "root",
                                                    totalProperty: "totalProperty"
                                                }
                                            },
                                            pageSize: 50,
                                            //remoteSort: true,
                                            fields: result.columns_name
                                       });

                                       store.on('beforeload', function (store, operation, eOpts) {
                                            Ext.apply(store.proxy.extraParams, {code: vs});
                                       });

                                       store.load({
                                            params: {
                                                code: vs,
                                                start: 0,
                                                limit: 50
                                            }
                                       });

                                       var grid = new Ext.grid.GridPanel({
                                            autoHeight: true,
                                            stripeRows: true,
                                            store: store,
                                            columns: result.columns,
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
                                            //bbar: bbar,
                                            dockedItems: [{
                                                xtype: 'pagingtoolbar',
                                                store: store,   // same store GridPanel is using
                                                dock: 'bottom',
                                                displayInfo: true
                                            }]
                                        });

                                       var p_grid = edit_form.getComponent('p_grid');
                                       p_grid.removeAll();

                                       var panel_panel = Ext.getCmp('panel_panel');
                                       p_grid.setHeight(panel_panel.getHeight() - 280);
                                       p_grid.add(grid);
                                       p_grid.show();

                                        grid.on('itemdblclick', function (v, record, item, index, e, eOpts) {
                                            var lst = [];
                                            for (var m in record.data)
                                            {
                                                lst.push({name: m, value: record.data[m]});
                                            }
                                            //console.log(lst);
                                            window.parent.show_win({data: lst});
                                        });
                                   },
                                   failure: function (response) {
                                       Ext.Msg.hide();

                                       var result = Ext.decode(response.responseText);
                                       Ext.Msg.show({
                                           title: '错误提示',
                                           msg: result.msg,
                                           buttons: Ext.Msg.OK,
                                           minWidth: 100
                                       });
                                   }
                               });
                           }
                           else
                           {
                               Ext.Msg.wait('正在运行，请稍候...', '信息提示');
                               Ext.Ajax.request({
                                   url: '/run_sql/',
                                   method: 'POST',
                                   params: {
                                       user_token: '${ m.user_token }',
                                       code: vs
                                   },
                                   success: function (response) {
                                       Ext.Msg.hide();
                                       var result = Ext.decode(response.responseText);

                                       var p_grid = edit_form.getComponent('p_grid');
                                           p_grid.hide();
                                           var p_error = edit_form.getComponent('p_error');
                                           p_error.removeAll();
                                           //console.log(p_error.getHeight());
                                           var panel_panel = Ext.getCmp('panel_panel');
                                           p_error.setHeight(panel_panel.getHeight() - 127 - 20);
                                           if (result.msg != null)
                                           {
                                               p_error.add(Ext.create('Ext.Component', {
                                                   html: result.msg
                                               }));
                                           }
                                           p_error.show();
                                   },
                                   failure: function (response) {
                                       Ext.Msg.hide();

                                       var result = Ext.decode(response.responseText);
                                       Ext.Msg.show({
                                           title: '错误提示',
                                           msg: result.msg,
                                           buttons: Ext.Msg.OK,
                                           minWidth: 100
                                       });
                                   }
                               });
                           }
                       }
                   }, '-', {
                       text: '保存到数据库',
                       handler: function () {
                           var vs = Ext.String.trim(editor.getSelection());
                           if (vs == '') {
                               vs = Ext.String.trim(editor.getValue());
                           }

                           if (vs == '')
                           {
                               return;
                           }

                           Ext.Msg.wait('正在保存代码，请稍候...', '信息提示');
                               Ext.Ajax.request({
                                   url: '/load_code/',
                                   method: 'POST',
                                   params: {
                                       user_token: '${ m.user_token }',
                                       code: vs
                                   },
                                   success: function (response) {
                                       Ext.Msg.hide();
                                       var result = Ext.decode(response.responseText);

                                       var p_grid = edit_form.getComponent('p_grid');
                                           p_grid.hide();
                                           var p_error = edit_form.getComponent('p_error');
                                           p_error.removeAll();
                                           //console.log(p_error.getHeight());
                                           var panel_panel = Ext.getCmp('panel_panel');
                                           p_error.setHeight(panel_panel.getHeight() - 127 - 20);
                                           if (result.msg != null)
                                           {
                                               p_error.add(Ext.create('Ext.Component', {
                                                   html: result.msg
                                               }));
                                           }
                                           p_error.show();
                                   },
                                   failure: function (response) {
                                       Ext.Msg.hide();

                                       var result = Ext.decode(response.responseText);
                                       Ext.Msg.show({
                                           title: '错误提示',
                                           msg: result.msg,
                                           buttons: Ext.Msg.OK,
                                           minWidth: 100
                                       });
                                   }
                               });
                       }
                   }]
               });

                var center = Ext.create('Ext.tab.Panel', {
                    //距两边间距
                    style: "padding:0 5px 0 5px",
                    region: "center",
                    //默认选中第一个
                    activeItem: 0,
                    //如果Tab过多会出现滚动条
                    enableTabScroll: true,
                    //加载时渲染所有
                    deferredRender: false,
                    layoutOnTabChange: true,
                    items: [{
                        xtype: "panel",
                        id: "panel_panel",
                        iconCls: "indexicon",
                        title: "工作台",
                        items: [edit_form],
                           listeners: {
                               afterrender: function (obj) {
                                   editor = CodeMirror.fromTextArea(document.getElementById('code_area'), {//根据DOM元素的id构造出一个编辑器
                                       lineNumbers: true,
                                       styleActiveLine: true,
                                       theme: "idea",//设置主题
                                       mode: 'text/x-mysql',
                                       //mode : 'text/x-plsql',
                                       hintOptions: {tables: source}
                                   });
                                   editor.setSize('auto', '227px');
                                   editor.on("keyup", function (cm, event) {
                                       if (!cm.state.completionActive//所有的字母和'$','{','.'在键按下之后都将触发自动完成
                                           && ((event.keyCode >= 65 && event.keyCode <= 90)
                                               || event.keyCode == 52 || event.keyCode == 219
                                               || event.keyCode == 190)) {
                                           CodeMirror.commands.autocomplete(cm, null, {
                                               completeSingle: false
                                           });
                                       }

                                       //my_localStore.set('code', Ext.String.trim(editor.getValue()));
                                       //console.log(my_localStore.get('code'));
                                       storage.setItem('code', Ext.String.trim(editor.getValue()));
                                       console.log(storage.getItem('code'));

                                   });

                                   //var my_code = my_localStore.get('code');
                                   var my_code = storage.getItem('code');
                                   if (my_code != null && my_code != '') {
                                       editor.setValue(my_code);
                                   }
                               }
                           },
                           bodyStyle :'overflow-x:hidden;overflow-y:scroll',
                           hidden: false
                    }]
                });

                Ext.define('cn.plus.tree.Panel', {
                   extend: 'Ext.tree.Panel',
                   region: 'west',
                   itemId: 'west_panel',
                   title: '数据库导航',
                   width: 200,
                   split: true,
                   collapsible: true,
                   floatable: true,
                   scroll: 'both',
                   autoScroll: true,
                   url: '',
                   listeners: {
                       "itemexpand": function (node, event) {
                           //console.log(node);
                           //console.log(event);
                           if (node.isLeaf()) {
                                event.stopEvent();
                                node.toggle();
                            }
                       },
                       'itemclick': function (node, record, item, index, e, eOpts) {
                         //e.stopEvent();
                           if (record.data.leaf)
                           {
                               e.stopEvent();

                               var id = "tab_id_" + record.data.id;
                                var n = center.getComponent(id);
                                if (!n) {
                                    var endIeStatus = document.getElementById("endIeStatus");
                                    if (document.createEvent) {
                                        var ev = document.createEvent('HTMLEvents');
                                        ev.initEvent('click', false, true);
                                        endIeStatus.dispatchEvent(ev);
                                    }
                                    else {
                                        endIeStatus.click();
                                    }
                                }

                                if (Ext.isEmpty(Ext.getCmp(id))) {
                                    var url = "/data/?schema=" + record.data.parentId + "&table_name=" + record.data.id;
                                    console.log(url);
                                    n = center.add({
                                        id: id,
                                        closable: true,
                                        layout: 'fit',
                                        title: record.data.text,
                                        // listeners: { activate: function() { Ext.getCmp('centerPanel').setTitle(node.text) } },
                                        html: '<iframe scrolling="auto" frameborder="0" width="100%" height="100%" src='+ url +'></iframe>'
                                    });
                                }
                                center.setActiveTab(n);
                           }
                        },
                       'afterlayout': function(treePanel, eOpts){
                            var emBody = document.getElementById(treePanel.body.id);
                            var emView = document.getElementById(treePanel.getView().id);
                            var emTable = document.getElementById(treePanel.getView().id).childNodes[0];
                            if(emTable != undefined){
                                var emTableW = emTable.style.width;
                                var newEmTableW = parseInt(emTable.style.width.substr(0,emTableW.length-2))-20;
                                emTable.style.width = newEmTableW+"px";
                                emTable.style.tableLayout = 'auto';
                                emTable.style.borderCollapse = 'separate';
                            }
                            emView.style.overflow = 'visible';
                            if(treePanel.treeGrid != 'Y'){
                                emView.style.overflowX = 'auto';
                            }else{
                                emView.style.overflowX = 'hidden';
                            }
                            emView.style.overflowY = 'auto';
                            emView.style.position = 'relative';
                            var emDivArr = emBody.parentNode.getElementsByTagName("div");
                               for(var i = 0; i < emDivArr.length; i++){
                                   var emDiv = emDivArr[i];
                                   if(emDiv.id.indexOf("gridscroller") == 0 && emDiv.className.indexOf("x-scroller-vertical") > 0){
                                       /*if(emDiv.parentNode != null){
                                           emDiv.parentNode.removeChild(emDiv);
                                       }*/
                                       emDiv.style.width = "0px";
                                       emView.style.width = treePanel.getWidth()+"px";
                                       emBody.style.width = treePanel.getWidth()+"px";
                                   }
                               }
                         }
                   },
                   //rootVisible: false,
                   initComponent: function () {
                       var me = this;

                       var store = Ext.create('Ext.data.TreeStore', {
                           autoLoad: false,
                           clearOnLoad: true,
                           clearRemovedOnLoad: true,
                           nodeParam:'id',
                           proxy: {
                               type: 'ajax',
                               //url: '/extjs_case/get_tree_store/',
                               url: me.url,
                               reader: {
                                   type: 'json',
                                   root: 'root'
                               }
                           },
                           root: {
                               expanded: true,
                               text: '根节点'
                           }
                       });

                       var base_config = {
                           store: store
                       };

                       Ext.apply(this, base_config);
                       this.callParent();
                   }
               });

                ShowWin = new Ext.Window({
                            title: '详情',
                            width: 730,
                            height: 468,
                            autoScroll: true,
                            maximizable: false,
                            resizable: true,
                            collapsible: true,
                            closeAction: 'hide',
                            closable: true,
                            modal: 'true',
                            buttonAlign: "center",
                            layout: 'fit',
                            bodyStyle: "padding:8px 8px 8px 8px",
                            bodyCfg: {
                                tag: 'center',
                                cls: 'x-panel-body',
                            },
                            contentEl: 'dawn_sql_show1'
                        }).show();
                ShowWin.hide();

                Ext.create('Ext.Viewport', {
                   layout: 'border',
                   title: 'MyPlus 的主界面',
                   defaults: {
                       //collapsible: true,
                       split: true
                   },
                   items: [{
                       xtype: 'panel',
                       region: 'north',
                       border: false,
                       tbar: tbar
                   }, Ext.create('cn.plus.tree.Panel', {url: '/tree/?user_token=${ m.user_token }'}), center]
               });
            }
        });

        function show_win(data) {
            var tpl = new Ext.XTemplate(
				        '<table cellpadding="0" cellspacing="0" style="border:1px solid #b5e2ff;" width="630">',
                        '<tpl for="data">',
                        '<tr style="height:25px;">',
                        '<td class="t1" align="right">{name}：</td><td class="t2">&nbsp;&nbsp;<span>{value}</span></td>',
                        '</tr></tpl>',
                        '</table>'
				     );
				     tpl.overwrite(Ext.get("dawn_sql_show1"), data);

             ShowWin.show();
        }
    </script>
</head>
<body>
<a href="javascript:void(0);" onclick="javascript:endIeStatus();" id="endIeStatus" style="display: none;" />
<div id="dawn_sql_show1"></div>
</body>
</html>







































