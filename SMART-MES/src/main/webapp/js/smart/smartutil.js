//StringBuffer를 사용하기 위한 함수 정의/////
	var StringBuffer = function() {
	    this.buffer = new Array();
	}
	
	StringBuffer.prototype.append = function(str) {
		 this.buffer[this.buffer.length] = str;
	}
	
	StringBuffer.prototype.toString = function(){
	     return this.buffer.join("");
	}
	
	//HashMap 을 사용하기 위한 함수
	Map = function(){
		 this.map = new Object();
		}
	
	Map.prototype = {   
		    put : function(key, value){   
		        this.map[key] = value;
		    },   
		    get : function(key){   
		        return this.map[key];
		    },
		    containsKey : function(key){    
		     return key in this.map;
		    },
		    containsValue : function(value){    
		     for(var prop in this.map){
		      if(this.map[prop] == value) return true;
		     }
		     return false;
		    },
		    isEmpty : function(key){    
		     return (this.size() == 0);
		    },
		    clear : function(){   
		     for(var prop in this.map){
		      delete this.map[prop];
		     }
		    },
		    remove : function(key){    
		     delete this.map[key];
		    },
		    keys : function(){   
		        var keys = new Array();   
		        for(var prop in this.map){   
		            keys.push(prop);
		        }   
		        return keys;
		    },
		    values : function(){   
		     var values = new Array();   
		        for(var prop in this.map){   
		         values.push(this.map[prop]);
		        }   
		        return values;
		    },
		    size : function(){
		      var count = 0;
		      for (var prop in this.map) {
		        count++;
		      }
		      return count;
		    }
		};
	////////////////////////////////////////////////////
	
	
	/// 배열에서 특정 아이템을 해당 값으로 찾아서 제거//
	Array.prototype.deleteElem = function(val) {
	    var index = this.indexOf(val); 
	    if (index >= 0) this.splice(index, 1);
	    return this;
	}; 
	
	
	
	/**
     * 두 날짜의 차이를 일자로 구한다.(조회 종료일 - 조회 시작일)
     *
     * @param val1 - 조회 시작일(날짜 ex.2002-01-01)
     * @param val2 - 조회 종료일(날짜 ex.2002-01-01)
     * @return 기간에 해당하는 일자
     */
    function calDateRange(val1, val2)
    {
        var FORMAT = "-";

       

        // FORMAT을 포함한 길이 체크
        if (val1.length != 10 || val2.length != 10)
            return null;

 

        // FORMAT이 있는지 체크
        if (val1.indexOf(FORMAT) < 0 || val2.indexOf(FORMAT) < 0)
            return null;

 

        // 년도, 월, 일로 분리
        var start_dt = val1.split(FORMAT);
        var end_dt = val2.split(FORMAT);

 

        // 월 - 1(자바스크립트는 월이 0부터 시작하기 때문에...)
        // Number()를 이용하여 08, 09월을 10진수로 인식하게 함.
        start_dt[1] = (Number(start_dt[1]) - 1) + "";
        end_dt[1] = (Number(end_dt[1]) - 1) + "";

 

        var from_dt = new Date(start_dt[0], start_dt[1], start_dt[2]);
        var to_dt = new Date(end_dt[0], end_dt[1], end_dt[2]);

 

        return (to_dt.getTime() - from_dt.getTime()) / 1000 / 60 / 60 / 24;
    }
    
    
    function calDateRangeMonth(val1, val2)
    {
        var FORMAT = "-";

        // FORMAT을 포함한 길이 체크
        if (val1.length != 7 || val2.length != 7)
            return null;

        // FORMAT이 있는지 체크
        if (val1.indexOf(FORMAT) < 0 || val2.indexOf(FORMAT) < 0)
            return null;

        // 년도, 월로 분리
        var start_dt = val1.split(FORMAT);
        var end_dt = val2.split(FORMAT);

        // 월 - 1(자바스크립트는 월이 0부터 시작하기 때문에...)
        // Number()를 이용하여 08, 09월을 10진수로 인식하게 함.
        start_dt[1] = (Number(start_dt[1]) - 1) + "";
        end_dt[1] = (Number(end_dt[1]) - 1) + "";

        var strtYear = parseInt(start_dt[0]);
        var strtMonth = parseInt(start_dt[1]);

        var endYear = parseInt(end_dt[0]);
        var endMonth = parseInt(end_dt[1]);

        var month = (endYear - strtYear)* 12 + (endMonth - strtMonth);
 

        return month;
    }
    
    
    function calDateRangeHour(sDate, shour, stime, eDate, ehour, etime)
    {
        var FORMAT = "-";
  
        // FORMAT을 포함한 길이 체크
        if (sDate.length != 10 || eDate.length != 10)
            return null;
 
        // FORMAT이 있는지 체크
        if (sDate.indexOf(FORMAT) < 0 || eDate.indexOf(FORMAT) < 0)
            return null;
 
        // 년도, 월, 일로 분리
        var start_dt = sDate.split(FORMAT);
        var end_dt = eDate.split(FORMAT);
         // 월 - 1(자바스크립트는 월이 0부터 시작하기 때문에...)
        // Number()를 이용하여 08, 09월을 10진수로 인식하게 함.
        start_dt[1] = (Number(start_dt[1]) - 1) + "";
        end_dt[1] = (Number(end_dt[1]) - 1) + "";
 
        var from_dt = new Date(start_dt[0], start_dt[1], start_dt[2], shour, stime);
        var to_dt = new Date(end_dt[0], end_dt[1], end_dt[2], ehour, etime);
  
  
	    var chkDate = (to_dt.getTime() - from_dt.getTime());
	    
	    if(chkDate < 0 ) 
	    {
	     alert("종료시간이 시작시간 이전이면 안됩니다. 다시 확인하세요.");
	     return false;
	    }
  
        return (to_dt.getTime() - from_dt.getTime()) / 1000 / 60 / 60 /24;
    }
    
    
    function rgb2hex(rgb) {
    	if (  rgb.search("rgb") == -1 ) {
            return rgb;
       } else {
            rgb = rgb.match(/^rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*(\d+))?\)$/);
            function hex(x) {
                 return ("0" + parseInt(x).toString(16)).slice(-2);
            }
            return ("#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3])).toUpperCase(); 
       }
    }
	
	
    function nvl(value,replacer)
    {
    	if(value == null || value == ""){
    		return replacer;
    	}else{
    		return value;
    	}
    }
    
    
  //YYYY-MM-DD
    function getDateFormat(date)
    {
    	var yyyy = date.getFullYear().toString();
        var mm = (date.getMonth() + 1).toString();
        var dd = date.getDate().toString();

        return yyyy + "-" + (mm[1] ? mm : '0'+mm[0]) + "-" + (dd[1] ? dd : '0'+dd[0]);
    }
	
	
  //YYYYMMDD
    function getDateNumberFormat(date)
    {
    	var yyyy = date.getFullYear().toString();
        var mm = (date.getMonth() + 1).toString();
        var dd = date.getDate().toString();

        return yyyy + (mm[1] ? mm : '0'+mm[0]) + (dd[1] ? dd : '0'+dd[0]);
    }
    
    
  //YYYYMMDDHH24
    function getDateHourNumberFormat(date)
    {
    	var yyyy = date.getFullYear().toString();
        var mm = (date.getMonth() + 1).toString();
        var dd = date.getDate().toString();
        var hh = date.getHours().toString();

        return yyyy + (mm[1] ? mm : '0'+mm[0]) + (dd[1] ? dd : '0'+dd[0]) + (hh[1] ? hh : '0'+hh[0]);
    }
  
		
    //세자리수 마다 쉼표 찍기
    Number.prototype.format = function(){
        if(this==0) return 0;
     
        var reg = /(^[+-]?\d+)(\d{3})/;
        var n = (this + '');
     
        while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
     
        return n;
    };
    
    
    function replaceAll(str, searchStr, replaceStr) {

        return str.split(searchStr).join(replaceStr);
    }
    
    
    function getStrLengthOver(str,len)
    {
    	if(str != null && str.length>len )
    	{
    		str = str.substring(0,len) + "..";
    	}
    	
    	return str;
    }
    
    
    function add_months(dt, n)   
    {  
    	return new Date(dt.setMonth(dt.getMonth() + n,1));        
    }
    
    
    String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
    String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
    Number.prototype.zf = function(len){return this.toString().zf(len);};
    Date.prototype.format = function(f) {
        if (!this.valueOf()) return " ";
     
        var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
        var d = this;
         
        return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
            switch ($1) {
                case "yyyy": return d.getFullYear();
                case "yy": return (d.getFullYear() % 1000).zf(2);
                case "MM": return (d.getMonth() + 1).zf(2);
                case "dd": return d.getDate().zf(2);
                case "E": return weekName[d.getDay()];
                case "HH": return d.getHours().zf(2);
                case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
                case "mm": return d.getMinutes().zf(2);
                case "ss": return d.getSeconds().zf(2);
                case "a/p": return d.getHours() < 12 ? "오전" : "오후";
                default: return $1;
            }
        });
    };
	