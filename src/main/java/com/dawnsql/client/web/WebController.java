package com.dawnsql.client.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
public class WebController {

    @RequestMapping(value = "/index")
    public String index(ModelMap model, HttpServletRequest request,
                            HttpServletResponse response)
    {
        return "index";
    }

    @RequestMapping(value = "/introduce")
    public String introduce(ModelMap model, HttpServletRequest request,
                        HttpServletResponse response)
    {
        return "introduce";
    }

    @RequestMapping(value = "/installation")
    public String installation(ModelMap model, HttpServletRequest request,
                        HttpServletResponse response)
    {
        return "installation";
    }

    @RequestMapping(value = "/linkdb")
    public String linkdb(ModelMap model, HttpServletRequest request,
                        HttpServletResponse response)
    {
        return "linkdb";
    }

    @RequestMapping(value = "/design")
    public String design(ModelMap model, HttpServletRequest request,
                        HttpServletResponse response)
    {
        return "design";
    }

    @RequestMapping(value = "/support")
    public String support(ModelMap model, HttpServletRequest request,
                        HttpServletResponse response)
    {
        return "support";
    }

    @RequestMapping(value = "/ddl")
    public String ddl(ModelMap model, HttpServletRequest request,
                        HttpServletResponse response)
    {
        return "ddl";
    }

    @RequestMapping(value = "/dml")
    public String dml(ModelMap model, HttpServletRequest request,
                        HttpServletResponse response)
    {
        return "dml";
    }

    @RequestMapping(value = "/nosql")
    public String nosql(ModelMap model, HttpServletRequest request,
                      HttpServletResponse response)
    {
        return "nosql";
    }

    @RequestMapping(value = "/schedule")
    public String schedule(ModelMap model, HttpServletRequest request,
                      HttpServletResponse response)
    {
        return "schedule";
    }

    @RequestMapping(value = "/hp")
    public String hp(ModelMap model, HttpServletRequest request,
                      HttpServletResponse response)
    {
        return "hp";
    }

    @RequestMapping(value = "/customextension")
    public String customextension(ModelMap model, HttpServletRequest request,
                      HttpServletResponse response)
    {
        return "customextension";
    }

    @RequestMapping(value = "/jdbc")
    public String jdbc(ModelMap model, HttpServletRequest request,
                      HttpServletResponse response)
    {
        return "jdbc";
    }

    @RequestMapping(value = "/ml")
    public String ml(ModelMap model, HttpServletRequest request,
                      HttpServletResponse response)
    {
        return "ml";
    }

    @RequestMapping(value = "/cluster")
    public String cluster(ModelMap model, HttpServletRequest request,
                      HttpServletResponse response)
    {
        return "cluster";
    }

    @RequestMapping(value = "/whydawnsql")
    public String whydawnsql(ModelMap model, HttpServletRequest request,
                          HttpServletResponse response)
    {
        return "whydawnsql";
    }

    @RequestMapping(value = "/dawnsql")
    public String dawnsql(ModelMap model, HttpServletRequest request,
                          HttpServletResponse response)
    {
        return "dawnsql";
    }

    @RequestMapping(value = "/dawndb")
    public String dawndb(ModelMap model, HttpServletRequest request,
                          HttpServletResponse response)
    {
        return "dawndb";
    }

    @RequestMapping(value = "/func")
    public String func(ModelMap model, HttpServletRequest request,
                          HttpServletResponse response)
    {
        return "func";
    }

    @RequestMapping(value = "/team")
    public String team(ModelMap model, HttpServletRequest request,
                          HttpServletResponse response)
    {
        return "team";
    }

    @RequestMapping(value = "/my_team")
    public String my_team(ModelMap model, HttpServletRequest request,
                          HttpServletResponse response)
    {
        return "my_team";
    }

}
