!function(){"use strict";const e={};require.config({onNodeCreated:function(o,a,n){e[n]&&(o.setAttribute("integrity",e[n]),o.setAttribute("crossorigin","anonymous"))}});const o=require.load;require.load=function(a,n,s){return e[n]&&(s=s+"?hash="+e[n]),o.apply(this,[a,n,s])}}();