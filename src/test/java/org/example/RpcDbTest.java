package org.example;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.dawnsql.client.rpc.RpcClient;
import com.dawnsql.client.tools.RpcDb;
import org.junit.Test;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RpcDbTest {

    private Gson gson = new GsonBuilder()
            .enableComplexMapKeySerialization()
            .setDateFormat("yyyy-MM-dd HH:mm:ss")
            .create();

    private RpcClient instance = new RpcClient();

    @Test
    public void get_schemas()
    {
        String rs = instance.executeSqlQuery("dafu", "SELECT SCHEMA_NAME FROM sys.SCHEMAS", "schema");
        List<List<?>> my_rs = gson.fromJson(rs, new TypeToken<List<List<?>>>(){}.getType());
        for (List<?> r : my_rs)
        {
            HashMap<String, String> hashMap = new HashMap<>();
            hashMap.put("id", r.get(0).toString());
            hashMap.put("text", r.get(0).toString());
            System.out.println(hashMap);
        }
    }

    @Test
    public void get_tables()
    {
        String schema_name = "MY_META";
        String rs = instance.executeSqlQuery("dafu", String.format("SELECT TABLE_NAME FROM sys.TABLES WHERE SCHEMA_NAME = '%s'", schema_name), "schema");
        List<List<?>> my_rs = gson.fromJson(rs, new TypeToken<List<List<?>>>(){}.getType());
        for (List<?> r : my_rs)
        {
            HashMap<String, Object> hashMap = new HashMap<>();
            hashMap.put("id", r.get(0).toString());
            hashMap.put("text", r.get(0).toString());
            hashMap.put("schema", schema_name);
            hashMap.put("text", true);
            System.out.println(hashMap);
        }
    }

    @Test
    public void read_column_meta()
    {
        String schema_name = "MY_META";
        String table_name = "MY_SELECT_VIEWS";
        String rs = instance.executeSqlQuery("dafu", String.format("SELECT * FROM %s.%s", schema_name, table_name), "meta");
        Map<String, Integer> my_rs = gson.fromJson(rs, new TypeToken<Map<String, Integer>>() {
        }.getType());
        for (String key : my_rs.keySet())
        {
            System.out.println(key + " " + String.valueOf(my_rs.get(key)));
        }
    }

    @Test
    public void register_db()
    {
        String group_name = "wudafu";
        String user_token = "token";
        String sql = String.format("create schema %s;add_user_group('%s', '%s', 'all', '%s');", group_name, group_name, group_name + user_token, group_name);
        String rs = instance.executeSqlQuery("", sql, "my_meta");
        System.out.println(rs);
    }

    @Test
    public void re_register()
    {
        String group_name = "wudafu";
        String rs = instance.executeSqlQuery("", String.format("SELECT m.id FROM MY_META.MY_USERS_GROUP m WHERE m.GROUP_NAME = '%s'", group_name), "schema");
        List<List<?>> my_rs = gson.fromJson(rs, new TypeToken<List<List<?>>>(){}.getType());
        for (List<?> row : my_rs)
        {
            System.out.println(row);
        }
    }

    @Test
    public void login()
    {
        String group_name = "wudafu";
        String user_token = group_name + "token";
        String rs = instance.executeSqlQuery("", String.format("SELECT m.id FROM MY_META.MY_USERS_GROUP m WHERE m.USER_TOKEN = '%s'", user_token), "schema");
        List<List<?>> my_rs = gson.fromJson(rs, new TypeToken<List<List<?>>>(){}.getType());
        for (List<?> row : my_rs)
        {
            System.out.println(row);
        }
    }

    @Test
    public void get_table_count()
    {
        String user_token = "dafu";
        String schema = "sys";
        String table_name = "TABLES";
        String rs = instance.executeSqlQuery(user_token, String.format("SELECT count(*) FROM %s.%s", schema, table_name), "count");
        Integer my_rs = gson.fromJson(rs, new TypeToken<Integer>(){}.getType());
        System.out.println(my_rs);
    }

    @Test
    public void get_table_row()
    {
//        List<List<?>> my_rs = MyRpcDb.get_table_row("dafu", "sys", "TABLES", 0, 3);
//        for (List<?> row : my_rs)
//        {
//            System.out.println(row);
//        }

        String user_token = "dafu";
        String schema = "sys";
        String table_name = "TABLES";
        Integer start = 0;
        Integer limit = 3;

        HashMap<String, Integer> ps = new HashMap<>();
        ps.put("start", start);
        ps.put("limit", limit);
        ps.put("row", 1);
        String sql = String.format("SELECT * FROM %s.%s", schema, table_name);
        String rs = instance.executeSqlQuery(user_token, sql, gson.toJson(ps));
        System.out.println(rs);
    }

    @Test
    public void run_select_meta()
    {
        HashMap<String, Object> map = RpcDb.run_select_meta("dafu", "SELECT * FROM MY_META.MY_SELECT_VIEWS");
        System.out.println(map);
    }

    @Test
    public void run_dawn_sql()
    {
        HashMap<String, Object> map = RpcDb.run_dawn_sql("dafu", "SELECT * FROM MY_META.MY_SELECT_VIEWS");
        System.out.println(map);
    }

    @Test
    public void run_select()
    {
        String rs = RpcDb.run_select("dafu", "SELECT * FROM MY_META.MY_SELECT_VIEWS", 0, 3);
        System.out.println(rs);
    }

    @Test
    public void load_code()
    {
        HashMap<String, Object> rs = RpcDb.load_code("dafu", "function helloWorld(msg:String)" +
                "{" +
                "    show_msg(msg);" +
                "}");
        System.out.println(rs);
    }
}

























