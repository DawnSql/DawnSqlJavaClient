<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>操作数据库的函数</title>
    <link href="../bt/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="../bt/css/bootstrap-grid.min.css" rel="stylesheet"/>
    <link href="../css/page.css" rel="stylesheet"/>
    <script type="text/javascript" src="http://ajax.microsoft.com/ajax/jquery/jquery-1.9.1.min.js"></script>
    <script src="../bt/js/bootstrap.min.js" type="text/javascript"></script>
    <style type="text/css">
        .no_list_style {
            list-style-type: none;
        }
        .a_c {
            color: #007bff;
        }
    </style>
    <script type="text/javascript">
        $(function () {
             $('.content').find('ul').find('li').addClass('no_list_style');
             $('.content').find('a').addClass('a_c');
        });

        function set_show_doc(ht)
        {
            $('#show_doc').height(ht + 25);
        }
    </script>
</head>
<body>
    <header id="header">
        <ul id="nav">
            <li><a href="<c:url value="/guide/" />" class="nav-link">入门指南</a></li>
            <li><a href="<c:url value="/whydawnsql/" />" class="nav-link">DawnSql语言</a></li>
            <li><a href="<c:url value="/func/" />" class="nav-link">速查表(掌中宝)</a></li>
            <li><a href="<c:url value="/dawnclient/" />" class="nav-link">试用</a></li>
            <!--
            <li><a href="<c:url value="/suggest/" />" class="nav-link">开发建议</a></li>
            -->
            <li><a href="<c:url value="/team/" />" class="nav-link team">团队</a></li>
        </ul>
    </header>
    <div id="main" class="fix-sidebar">
        <div class="sidebar">
            <div class="sidebar-inner">
                <div class="list">
                    <ul class="menu-root">
                        <li><a href="<c:url value="/whydawnsql" />" style="text-decoration: none;" class="sidebar-link">为什么要发明DawnSql语言</a></li>
                        <li><a href="<c:url value="/dawnsql/" />" style="text-decoration: none;" class="sidebar-link">DawnSql语法</a></li>
                        <li><a href="<c:url value="/dawndb/" />" style="text-decoration: none;" class="sidebar-link current">操作数据库的函数</a></li>
                    </ul>
                </div>
            </div>
        </div>
        <div id="show_doc" class="content guide with-sidebar installation-guide">
            <iframe src='../page/DawnSql操作数据库的函数_3.html' scrolling='no' style="overflow:visible;" frameborder='0' width='100%' height='100%'></iframe>
        </div>
    </div>
</body>
</html>

































