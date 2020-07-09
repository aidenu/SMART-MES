String.prototype.comma = function() {
	     tmp = this.split('.');
	     var str = new Array();
	     var v = tmp[0].replace(/,/gi,'');
	     for(var i=0; i<=v.length; i++) {
	         str[str.length] = v.charAt(v.length-i);
	         if(i%3==0 && i!=0 && i!=v.length) {
	             str[str.length] = '.';
	         }
	     }
	     str = str.reverse().join('').replace(/\./gi,',');
	     return (tmp.length==2) ? str + '.' + tmp[1] : str;
	 }


 function onlyNum(obj) {
     var val = obj.value;
     var re = /[^0-9\.\,\-]/gi;
     obj.value = val.replace(re, '');
 }
 
 
function checkStrLength( strsize, obj )
 {
     if (obj.value.length > strsize)
     {
         if (event.keyCode != '8') //백스페이스는 지우기작업시 바이트 체크하지 않기 위해서
         {
             alert( 'Insert limit size is ' + strsize);
         }
         
         objvalue = obj.value.substring(0, strsize);
     }
}


function checkQuota(obj)
{
	var val = obj.value;
    var re = /[\"\<\>]/gi;
    obj.value = val.replace(re, '');
}