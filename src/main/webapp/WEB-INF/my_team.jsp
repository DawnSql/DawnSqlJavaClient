<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>团队</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" integrity="sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu" crossorigin="anonymous">
</head>
<body>
<div id="my_show">
    <div class="container-fluid">
        <div class="row">
            <p>
          Dawn Sql 起源于大型金融集团的脱 O 项目。我们团队从 2018 年起，做了很多 POC，把现在主流的数据库、技术方案全部都做了一遍。得出了一个结论：在企业应用领域，如果要完全的脱 O ，那么就需要一个和 Oracle 一样支持 PKG，且在功能和性能上可以媲美 Oracle 的数据库。**如果在脱 O 的过程中，还要提升开发的产能同时修改 PKG 的缺点。那么就需要一个新的业务描述语言来替代 PKG，同时还能提升数据库的性能和扩展数据的功能。**
  基于上面的结论和我们长期实践的结果，我们改造了 Apache Ignite 修改了相应的缺陷，扩展了其功能，创造了 Dawn Sql 这种业务描述语言，让两者有机的结合起来。
  从我们长期实践的经验中，我们创造性的提出了，新的企业应用架构方向：函数式架构。
      </p>

            <table class="table table-striped">
                <thead>
                    <tr>
                      <th>贡献者</th>
                      <th>title</th>
                      <th>github</th>
                      <th>email</th>
                    </tr>
                  </thead>
                <tbody>
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    </div>
<!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
    <script type="text/javascript" src="http://ajax.microsoft.com/ajax/jquery/jquery-1.9.1.min.js"></script>
    <!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js" integrity="sha384-aJ21OjlMXNL5UyIl/XNwTMqvzeRMZH2w8c5cRVpzpU8Y5bApTppSuUkhZXN0VxHd" crossorigin="anonymous"></script>
    <script type="text/javascript">
        $(function () {
            window.parent.set_show_doc($('#my_show').height());
        });
    </script>
</body>
</html>

































