package com.dawnsql.client.tools;

import com.google.common.base.Strings;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.dawnsql.client.rpc.RpcClient;

import java.util.*;

public class RpcDb {

    private static Gson gson = new GsonBuilder()
            .enableComplexMapKeySerialization()
            .setDateFormat("yyyy-MM-dd HH:mm:ss")
            .create();

    private static RpcClient instance = new RpcClient();

    /**
     * 读取所有的 schema
     * */
    public static List<HashMap<String, String>> get_schemas(String user_token)
    {
        List<HashMap<String, String>> root = new ArrayList<>();
        String rs = instance.executeSqlQuery(user_token, "SELECT SCHEMA_NAME FROM sys.SCHEMAS", "schema");
        List<List<?>> my_rs = gson.fromJson(rs, new TypeToken<List<List<?>>>(){}.getType());
        for (List<?> r : my_rs)
        {
            HashMap<String, String> hashMap = new HashMap<>();
            hashMap.put("id", r.get(0).toString());
            hashMap.put("text", r.get(0).toString());
            root.add(hashMap);
        }
        return root;
    }

    /**
     * 读取所有的 schema
     * */
    public static List<HashMap<String, Object>> get_tables(String user_token, String schema_name)
    {
        List<HashMap<String, Object>> root = new ArrayList<>();
        String rs = instance.executeSqlQuery(user_token, String.format("SELECT TABLE_NAME FROM sys.TABLES WHERE SCHEMA_NAME = '%s'", schema_name), "schema");
        List<List<?>> my_rs = gson.fromJson(rs, new TypeToken<List<List<?>>>(){}.getType());
        for (List<?> r : my_rs)
        {
            HashMap<String, Object> hashMap = new HashMap<>();
            hashMap.put("id", r.get(0).toString());
            hashMap.put("text", r.get(0).toString());
            hashMap.put("schema", schema_name);
            hashMap.put("leaf", true);
            root.add(hashMap);
        }
        return root;
    }

    /**
     * 读取表的列
     * */
    public static HashMap<String, Object> read_column_meta(String user_token, String schema_name, String table_name)
    {
        HashMap<String, Object> hashMap = new HashMap<>();
        try {
            String rs = instance.executeSqlQuery(user_token, String.format("SELECT * FROM %s.%s", schema_name, table_name), "meta");
            Map<String, Integer> my_rs = gson.fromJson(rs, new TypeToken<Map<String, Integer>>() {
            }.getType());
            hashMap.put("success", my_rs);
        } catch (Exception e)
        {
            String rs = instance.executeSqlQuery(user_token, String.format("SELECT * FROM %s.%s", schema_name, table_name), "meta");
            Map<String, String> my_rs = gson.fromJson(rs, new TypeToken<Map<String, Integer>>() {
            }.getType());
            hashMap.put("err", my_rs);
        }
        return hashMap;
    }

    /**
     * 判断是否注册
     * */
    public static List<List<?>> re_register(String group_name)
    {
        String rs = instance.executeSqlQuery("", String.format("SELECT m.id FROM MY_META.MY_USERS_GROUP m WHERE m.GROUP_NAME = '%s'", group_name), "schema");
        List<List<?>> my_rs = gson.fromJson(rs, new TypeToken<List<List<?>>>(){}.getType());
        return my_rs;
    }

    /**
     * 登录
     * */
    public static List<List<?>> login(String user_token)
    {
        String rs = instance.executeSqlQuery("", String.format("SELECT m.id FROM MY_META.MY_USERS_GROUP m WHERE m.USER_TOKEN = '%s'", user_token), "schema");
        List<List<?>> my_rs = gson.fromJson(rs, new TypeToken<List<List<?>>>(){}.getType());
        return my_rs;
    }

    /**
     * 登录
     * */
    public static int register_db(String group_name, String user_token)
    {
        String rs = instance.executeSqlQuery("", String.format("create schema %s;add_user_group('%s', '%s', 'all', '%s');", group_name, group_name + user_token), "my_meta");
        if (!Strings.isNullOrEmpty(rs))
            return 1;
        return 0;
    }

    /**
     * 读取表的 count
     * */
    public static Integer get_table_count(String user_token, String schema, String table_name)
    {
        String rs = instance.executeSqlQuery(user_token, String.format("SELECT count(*) FROM %s.%s", schema, table_name), "count");
        Integer my_rs = gson.fromJson(rs, new TypeToken<Integer>(){}.getType());
        return my_rs;
    }

    /**
     * 读取表的 row
     * */
    public static String get_table_row(String user_token, String schema, String table_name, Integer start, Integer limit)
    {
        HashMap<String, Integer> ps = new HashMap<>();
        ps.put("start", start);
        ps.put("limit", limit);
        ps.put("row", 1);
        String rs = instance.executeSqlQuery(user_token, String.format("SELECT * FROM %s.%s", schema, table_name), gson.toJson(ps));
        return rs;
    }

    /**
     * 执行 select 语句
     * */
    public static HashMap<String, Object> run_select_meta(String user_token, String sql)
    {
        HashMap<String, Object> hashMap = new HashMap<>();
        try {
            String rs = instance.executeSqlQuery(user_token, sql, "meta");
            Map<String, Integer> my_rs = gson.fromJson(rs, new TypeToken<Map<String, Integer>>() {
            }.getType());
            hashMap.put("success", my_rs);
        } catch (Exception e)
        {
            String rs = instance.executeSqlQuery(user_token, sql, "meta");
            Map<String, String> my_rs = gson.fromJson(rs, new TypeToken<Map<String, String>>() {
            }.getType());
            hashMap.put("err", my_rs);
        }
        return hashMap;
    }

    /**
     * 执行 Dawn Sql 语句
     * */
    public static HashMap<String, Object> run_dawn_sql(String user_token, String sql)
    {
        String rs = instance.executeSqlQuery(user_token, sql, "");
        try {
            HashMap<String, Object> ht = new HashMap<>();
            ht.put("msg", rs);
            return ht;
        } catch (Exception e)
        {
            HashMap<String, Object> my_rs = gson.fromJson(rs, new TypeToken<HashMap<String, Object>>() {
            }.getType());
            HashMap<String, Object> ht = new HashMap<>();
            ht.put("msg", my_rs.get("err"));
            return ht;
        }
    }

    /**
     * 执行 select 语句
     * */
    public static String run_select(String user_token, String sql, Integer start, Integer limit)
    {
        HashMap<String, Integer> ps = new HashMap<>();
        ps.put("start", start);
        ps.put("limit", limit);
        ps.put("select", 1);
        String rs = instance.executeSqlQuery(user_token, sql, gson.toJson(ps));
        //List<List<?>> my_rs = gson.fromJson(rs, new TypeToken<List<List<?>>>(){}.getType());
        return rs;
    }

    /**
     * load code to db
     * */
    public static HashMap<String, Object> load_code(String user_token, String sql)
    {
        String rs = instance.executeSqlQuery(user_token, sql, "load");
        if (Strings.isNullOrEmpty(rs))
        {
            HashMap<String, Object> ht = new HashMap<>();
            ht.put("msg", "保存成功！");
            return ht;
        }
        else
        {
            try {
                HashMap<String, Object> my_rs = gson.fromJson(rs, new TypeToken<HashMap<String, Object>>() {
                }.getType());
                HashMap<String, Object> ht = new HashMap<>();
                ht.put("msg", my_rs.get("err"));
                return ht;
            } catch (Exception e)
            {
                e.printStackTrace();
            }
        }

        HashMap<String, Object> ht = new HashMap<>();
        ht.put("msg", "保存失败！");
        return ht;
    }
}















































