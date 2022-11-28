/**
 * 扩展 VType
 * 用法：
 *                 fieldLabel: '成人年龄',
                   name: 'age',
                   vtype: 'age'

 扩展后 password 的使用方式：
 //配置items参数
items:[
    {
        fieldLabel  : "密码",
        id          : "pass1",
    },{
        fieldLabel  : "确认密码",
        id          : "pass2",
        vtype       : "password",//自定义的验证类型
        vtypeText   : "两次密码不一致！",
        confirmTo   : "pass1",//要比较的另外一个的组件的id
    }
]

 * */

/**
 * 判断 IP
 * */
function is_ip(ip_str) {
    try {
        var lst = new Array();
        var vs = ip_str.split('.');
        if (vs.length == 4)
        {
            for(var i = 0; i < vs.length; i++)
            {
                if (parseInt(vs[i]) >= 0 && parseInt(vs[i]) < 1000)
                {
                    lst.push(vs[i]);
                }
            }
        }

        if (lst.length == 4)
        {
            return true;
        }
        return false;
    }
    catch (e) {
        return false;
    }
}

Ext.apply(Ext.form.VTypes, {
    ip:function(val,field) {
        var vs = is_ip(val);
        return vs;
    },
    ipText:'请输入正确的IP地址',
    password: function(val, field){
        if (field.initialPassField)
        {
            var pwd = Ext.getCmp(field.initialPassField);
            return (val == pwd.getValue());
        }
    },
    passwordText: '两次输入的密码不一致！'
});

// Ext.apply(Ext.form.VTypes,
// {
//     daterange: function(val, field)
//     {
//         var date = field.parseDate(val);
//
//         // We need to force the picker to update values to recaluate the disabled dates display
//         var dispUpd = function(picker)
//         {
//             var ad = picker.activeDate;
//             picker.activeDate = null;
//             picker.update(ad);
//         };
//
//         if (field.startDateField)
//         {
//             var sd = Ext.getCmp(field.startDateField);
//             sd.maxValue = date;
//             if (sd.menu && sd.menu.picker)
//             {
//                 sd.menu.picker.maxDate = date;
//                 dispUpd(sd.menu.picker);
//             }
//         }
//         else if (field.endDateField)
//         {
//             var ed = Ext.getCmp(field.endDateField);
//             ed.minValue = date;
//             if (ed.menu && ed.menu.picker)
//             {
//                 ed.menu.picker.minDate = date;
//                 dispUpd(ed.menu.picker);
//             }
//         }
//         return true;
//     },
//
//   password: function(val, field)
//   {
//         if (field.initialPassField)
//         {
//             var pwd = Ext.getCmp(field.initialPassField);
//             return (val == pwd.getValue());
//         }
//         return true;
//   },
//   passwordText: '两次输入的密码不一致！',
//
//   chinese:function(val,field)
//   {
//         var reg = /^[/u4e00-/u9fa5]+$/i;
//         if(!reg.test(val))
//         {
//             return false;
//         }
//         return true;
//   },
//   chineseText:'请输入中文',
//
//   age:function(val,field)
//   {
//         try
//         {
//             if(parseInt(val) >= 18 && parseInt(val) <= 100)
//                 return true;
//             return false;
//         }
//         catch(err)
//         {
//             return false;
//         }
//   },
//   ageText:'年龄输入有误',
//
//   alphanum:function(val,field)
//   {
//         try
//         {
//             if(!//W/.test(val))
//                 return true;
//             return false;
//         }
//         catch(e)
//         {
//             return false;
//         }
//   },
//   alphanumText:'请输入英文字母或是数字,其它字符是不允许的.',
//
//   url:function(val,field)
//   {
//         try
//         {
//             if(/^(http|https|ftp):////(([A-Z0-9][A-Z0-9_-]*)(/.[A-Z0-9][A-Z0-9_-]*)+)(:(/d+))?//?/i.test(val))
//                 return true;
//             return false;
//         }
//         catch(e)
//         {
//             return false;
//         }
//   },
//   urlText:'请输入有效的URL地址.',
//
//   max:function(val,field)
//   {
//         try
//         {
//             if(parseFloat(val) <= parseFloat(field.max))
//                 return true;
//             return false;
//         }
//         catch(e)
//         {
//             return false;
//         }
//   },
//   maxText:'超过最大值',
//
//   min:function(val,field)
//   {
//         try
//         {
//             if(parseFloat(val) >= parseFloat(field.min))
//                 return true;
//             return false;
//         }
//         catch(e)
//         {
//             return false;
//         }
//   },
//   minText:'小于最小值',
//
//   datecn:function(val,field)
//   {
//         try
//         {
//             var regex = /^(/d{4})-(/d{2})-(/d{2})$/;
//             if(!regex.test(val)) return false;
//             var d = new Date(val.replace(regex, '$1/$2/$3'));
//             return (parseInt(RegExp.$2, 10) == (1+d.getMonth())) && (parseInt(RegExp.$3, 10) == d.getDate())&&(parseInt(RegExp.$1, 10) == d.getFullYear());
//         }
//         catch(e)
//         {
//             return false;
//         }
//   },
//   datecnText:'请使用这样的日期格式: yyyy-mm-dd. 例如:2008-06-20.',
//
//   integer:function(val,field)
//   {
//         try
//         {
//             if(/^[-+]?[/d]+$/.test(val))
//                 return true;
//             return false;
//         }
//         catch(e)
//         {
//             return false;
//         }
//   },
//   integerText:'请输入正确的整数',
//
//   minlength:function(val,field)
//   {
//         try
//         {
//             if(val.length >= parseInt(field.minlen))
//                 return true;
//             return false
//         }
//         catch(e)
//         {
//             return false;
//         }
//   },
//   minlengthText:'长度过小',
//
//   maxlength:function(val,field)
//   {
//      try
//      {
//         if(val.length <= parseInt(field.maxlen))
//             return true;
//         return false;
//      }
//      catch(e)
//      {
//         return false;
//      }
//   },
//   maxlengthText:'长度过大',
//
//   ip:function(val,field)
//   {
//         try
//         {
//             if((/^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(val)))
//                 return true;
//             return false;
//         }
//         catch(e)
//         {
//             return false;
//         }
//   },
//   ipText:'请输入正确的IP地址',
//
//   phone:function(val,field)
//   {
//         try
//         {
//             if(/^((0[1-9]{3})?(0[12][0-9])?[-])?/d{6,8}$/.test(val))
//                 return true;
//             return false;
//         }
//         catch(e)
//         {
//             return false;
//         }
//   },
//   phoneText:'请输入正确的电话号码,如:0920-29392929',
//
//   mobilephone:function(val,field)
//   {
//         try
//         {
//             if(/(^0?[1][35][0-9]{9}$)/.test(val))
//                 return true;
//             return false;
//         }
//         catch(e)
//         {
//             return false;
//         }
//   },
//   mobilephoneText:'请输入正确的手机号码',
//
//   alpha:function(val,field)
//   {
//         try
//         {
//             if( /^[a-zA-Z]+$/.test(val))
//                 return true;
//             return false;
//         }
//         catch(e)
//         {
//             return false;
//         }
//   },
//   alphaText:'请输入英文字母'
// });