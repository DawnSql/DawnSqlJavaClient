<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>登录</title>
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
                      <form id="from_register" action="<c:url value="/login_db/" />" method="post">
                    <div class="input-group" style="margin-bottom: 20px;">
                      <input type="password" class="form-control" id='user_token' name="user_token" placeholder="用户组名+user_token" aria-describedby="basic-addon2"/>
                        <span class="badge">例如：用户组名为：张三，user_token为：123，此处输入为：张三123</span>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                           <span class="input-group-btn">
                               <button class="btn btn-default" id="btn" type="button" style="margin-bottom: 28px;">登录</button>
                           </span>
                        </div>
                        <div class="col-md-6">
                           <span class="input-group-btn">
                              <a href="<c:url value="/register/" />" class="btn btn-default" style="margin-bottom: 28px;">注册</a>
                           </span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="checkbox" style="margin-left:18px;">
                          <label>
                            <input type="checkbox" id='chk' value="">
                            是否弹出 windows
                          </label>
                        </div>
                    </div>
                      </form>
                  </div>
                </div>
            </div>
        </div>
    </div>
<!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
    <script src="http://ajax.microsoft.com/ajax/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
    <!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js" integrity="sha384-aJ21OjlMXNL5UyIl/XNwTMqvzeRMZH2w8c5cRVpzpU8Y5bApTppSuUkhZXN0VxHd" crossorigin="anonymous"></script>
    <script type="text/javascript">
        $(function () {
            $('#btn').click(function () {
                var user_token = $.trim($('#user_token').val());
                if (user_token == '')
                {
                    alert('user_token 不能为空！');
                    return;
                }

                if ($('#chk').is(':checked'))
                {
                    $.get('<c:url value="/ajax_login_db/" />', {'user_token': user_token}, function (data) {
                        if (data.vs == 1)
                        {
                            window.open('<c:url value="/dawnclient/" />', 'DawnSql编辑器', 'top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');
                        }
                        else
                        {
                            alert('user_token 不存在！请仔细检查！');
                        }
                    });
                }
                else
                {
                    $('#from_register').submit();
                }

            });
        });
    </script>
</body>
</html>

































