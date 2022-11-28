package com.dawnsql.client.rpc;

import com.gridgain.dawn.rpc.RpcService;
import org.apache.thrift.TException;
import org.apache.thrift.protocol.TCompactProtocol;
import org.apache.thrift.protocol.TProtocol;
import org.apache.thrift.transport.TFramedTransport;
import org.apache.thrift.transport.TSocket;
import org.apache.thrift.transport.TTransport;
import org.apache.thrift.transport.TTransportException;

public class RpcClient {
    private TTransport transport = new TFramedTransport(new TSocket("127.0.0.1", 8091));
    private TProtocol protocol = new TCompactProtocol(transport);

    private RpcService.Client client = new RpcService.Client(protocol);

    public String executeSqlQuery(String userToken, String sql, String ps)
    {
        try {
            transport.open();
            return client.executeSqlQuery(userToken, sql, ps);
        } catch (TTransportException e) {
            e.printStackTrace();
        } catch (TException e) {
            e.printStackTrace();
        } finally {
            transport.close();
        }
        return null;
    }
}
