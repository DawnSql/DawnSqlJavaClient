<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>注册</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" integrity="sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu" crossorigin="anonymous">
</head>
<body>
    <div class="container-fluid" style="margin-top: 100px;">
        <div class="row">
            <div class="col-md-6">
                <div class="panel panel-primary">
                  <div class="panel-heading"><h3 class="panel-title">说明</h3></div>
                  <div class="panel-body">
                    <div class="list-group">
                      <a href="#" class="list-group-item">1、注册的名字，为 DawnSql 用户组的名字，并且注册成功后会为这个用户组分配一个 schema</a>
                      <a href="#" class="list-group-item">2、连接数据库用的是 user_token，注册成功后直接用 user_token 来登录即可</a>
                        <a href="#" class="list-group-item">3、为了让 user_token 不可能有重复，真实的 user_token 是用户组名+用户自己填写的 user_token</a>
                      <a href="#" class="list-group-item">4、Web 版的客户端包含了，绝大数的功能，但是不包括，root 用户的功能，用户要试用完整的功能还需要自己来下载安装文件</a>
                      <a href="#" class="list-group-item">5、Web 版的程序也是完全开源的！且可以集成到用户自己的应用程序中。例如：可以将它集成到 SAAS、PAAS、DAAS 中，方便你们客户扩展其应用</a>
                    </div>
                  </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="panel panel-primary">
                  <div class="panel-heading">
                    <h3 class="panel-title">注册</h3>
                  </div>
                  <div class="panel-body">
                      <form id="from_register" action="<c:url value="/register_db/" />" method="post">
                    <div class="input-group" style="margin-bottom: 20px;">
                      <input type="text" id="group_name" name="group_name" class="form-control" placeholder="用户组名称" aria-describedby="basic-addon1">
                    </div>

                    <div class="input-group" style="margin-bottom: 20px;">
                      <input type="password" id="user_token" name="user_token" class="form-control" placeholder="用户组 user_token" aria-describedby="basic-addon2">
                    </div>
                      <div class="input-group" style="margin-bottom: 20px;">
                      <input type="password" id="re_user_token" name="re_user_token" class="form-control" placeholder="重复用户组 user_token" aria-describedby="basic-addon2">
                    </div>
                      <span class="input-group-btn">
                        <button class="btn btn-default" type="button" id="btn" style="margin-bottom: 28px;">注册</button>
                      </span>
                          </form>
                  </div>
                </div>
            </div>
        </div>
    </div>
<!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
    <script src="/static/js/jquery-3.4.0.min.js" type="text/javascript"></script>
    <!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js" integrity="sha384-aJ21OjlMXNL5UyIl/XNwTMqvzeRMZH2w8c5cRVpzpU8Y5bApTppSuUkhZXN0VxHd" crossorigin="anonymous"></script>
    <script type="text/javascript">
        $(function () {
            $('#btn').click(function () {
                var group_name = $.trim($('#group_name').val());
                var user_token = $.trim($('#user_token').val());
                var re_user_token = $.trim($('#re_user_token').val());
                if (group_name == '')
                {
                    alert('用户组不能为空！');
                    return;
                }

                if (user_token == '')
                {
                    alert('user_token 不能为空！');
                    return;
                }

                if (re_user_token == '')
                {
                    alert('重复输入user_token 不能为空！');
                    return;
                }

                if (user_token != re_user_token)
                {
                    alert('user_token 和 重复输入user_token不相等！');
                    return;
                }

                $.get('<c:url value="/re_register/" />', {'group_name': group_name, 'user_token': user_token}, function (data) {
                    if (data.vs == 0)
                    {
                        $('#from_register').submit();
                    }
                    else
                    {
                        alert('用户组已经被注册，请重新填写，用户组和 user_token');
                    }
                });

            });
        });
    </script>
</body>
</html>
































































