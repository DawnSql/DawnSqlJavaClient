package com.dawnsql.client.web;

import com.dawnsql.client.tools.RpcDb;
import com.google.common.base.Strings;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.util.List;

@Controller
public class UserController {

    @RequestMapping(value = "/login")
    public String login(ModelMap model, HttpServletRequest request,
                        HttpServletResponse response)
    {
        return "login";
    }

    @RequestMapping(value = "/login_db")
    public String login_db(ModelMap model, HttpServletRequest request,
                        HttpServletResponse response,
                           @RequestParam(value = "user_token", required = false) String user_token) throws UnsupportedEncodingException {
        if (!Strings.isNullOrEmpty(user_token))
        {
            List<List<?>> vs = RpcDb.login(user_token);
            if (vs != null && vs.get(0).size() > 0)
            {
                HttpSession sessoin = request.getSession();
                sessoin.setAttribute("user_token", user_token);
//                Cookie cookie = new Cookie("user_token", user_token);
//                cookie.setPath(request.getContextPath());
//
//                //将cookie对象加入response响应
//                response.addCookie(cookie);
//
//                // 获取Cookie
//                Cookie[] cookies = request.getCookies();
//
//                // 遍历Cookie
//                for (Cookie aCookie : cookies) {
//                    String name = aCookie.getName();
//                    String value = aCookie.getValue();
//                    System.out.println(name);
//                    System.out.println(value);
//                    //aCookie.setMaxAge(0);
//                }

                return "redirect:/dawnclient";
                //return "login";
            }
        }
        return "redirect:/login";
    }

    @RequestMapping(value = "/ajax_login_db")
    public @ResponseBody
    String ajax_login_db(ModelMap model, HttpServletRequest request,
                         HttpServletResponse response, @RequestParam(value = "user_token", required = false) String user_token) throws UnsupportedEncodingException {
        if (!Strings.isNullOrEmpty(user_token))
        {
            List<List<?>> vs = RpcDb.login(user_token);
            if (vs != null && vs.get(0).size() > 0)
            {
                HttpSession sessoin = request.getSession();
                sessoin.setAttribute("user_token", user_token);
//                Cookie cookie = new Cookie("user_token", user_token);
//
//                //将cookie对象加入response响应
//                response.addCookie(cookie);
                return "{\"vs\": 1}";
            }
        }
        return "{\"vs\": 0}";
    }

    @RequestMapping(value = "/register")
    public String register(ModelMap model, HttpServletRequest request,
                        HttpServletResponse response)
    {
        return "register";
    }

    /**
     * 注册用户组
     * */
    @RequestMapping(value = "/register_db")
    public String register_db(ModelMap model, HttpServletRequest request, HttpServletResponse response,
                              @RequestParam(value = "user_token", required = false) String user_token,
                              @RequestParam(value = "group_name", required = false) String group_name) throws UnsupportedEncodingException {
        if (!Strings.isNullOrEmpty(user_token))
        {
            int vs = RpcDb.register_db(group_name, user_token);
            if (vs == 1)
            {
//                Cookie cookie = new Cookie("user_token", group_name + user_token);
//
//                //将cookie对象加入response响应
//                response.addCookie(cookie);
                HttpSession sessoin = request.getSession();
                sessoin.setAttribute("user_token", user_token);
                return "redirect:/dawnclient";
            }
        }
        return "redirect:/register";
    }

    /**
     * 判断是否注册
     * */
    @RequestMapping(value = "/re_register")
    public @ResponseBody
    String re_register(ModelMap model, HttpServletRequest request,
                         HttpServletResponse response, @RequestParam(value = "group_name", required = false) String group_name) throws UnsupportedEncodingException {
        if (!Strings.isNullOrEmpty(group_name))
        {
            List<List<?>> vs = RpcDb.re_register(group_name);
            if (vs != null && vs.get(0).size() > 0)
            {
                return "{\"vs\": 1}";
            }
        }
        return "{\"vs\": 0}";
    }
}












































