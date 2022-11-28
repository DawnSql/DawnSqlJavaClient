<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>展示数据</title>
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

    <script type="text/javascript">

            Ext.onReady(function () {
                var store_url = '/data_show/?schema=${ m.schema }&table_name=${ m.table_name }';
                var columns_name = eval('(' + document.getElementById('columns_name').innerText + ')');
                var columns = eval('(' + document.getElementById('columns').innerText + ')');

                var store = new Ext.data.JsonStore({
                    proxy:{
                        type: 'ajax',
                        url: store_url,
                        reader: {
                            type: 'json',
                            root: "root",
    	                    totalProperty: "totalProperty"
                        }
                    },
                    pageSize: 100,
    	            //remoteSort: true,
    	            fields: columns_name
                    /*
                    sorters: [{
                        property: 'id',
                        direction: 'DESC'
                    }]
                     */
    	        });

    	        store.load({
    	            params: {
    	                start: 0,
    	                limit: 100//bbar.pageSize
    	            }
    	        });

    	        var grid = new Ext.grid.GridPanel({
    	            autoHeight: true,
    	            renderTo: Ext.getBody(),
    	            stripeRows: true,
    	            store: store,
    	            columns: columns,
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

    	        grid.on('itemdblclick', function (v, record, item, index, e, eOpts) {
    	            var lst = [];
    	            for (var m in record.data)
                    {
                        lst.push({name: m, value: record.data[m]});
                    }
    	            //console.log(lst);
                    window.parent.show_win({data: lst});
                });
            });
        </script>
    </head>
    <body>
    <div id="columns_name" style="display:none;">
           ${ m.columns_name }
       </div>

        <div id="columns" style="display:none;">
           ${ m.columns }
       </div>
    </body>
    </html>

















