$(function () {
    var start = moment().subtract(29, "days");
    var end = moment();

    function cb(start, end) {
        $("#dateRange span").html(
            start.format("YYYY-MM-DD") + " ~ " + end.format("YYYY-MM-DD")
        );
        $("#startDate").val(start.format("YYYY-MM-DD"));
        $("#endDate").val(end.format("YYYY-MM-DD"));
    }

    $("#dateRange").daterangepicker(
        {
            startDate: start,
            endDate: end,
            ranges: {
                Today: [moment(), moment()],
                Yesterday: [
                    moment().subtract(1, "days"),
                    moment().subtract(1, "days"),
                ],
                "Last 7 Days": [moment().subtract(6, "days"), moment()],
                "Last 30 Days": [moment().subtract(29, "days"), moment()],
                "This Month": [
                    moment().startOf("month"),
                    moment().endOf("month"),
                ],
                "Last Month": [
                    moment().subtract(1, "month").startOf("month"),
                    moment().subtract(1, "month").endOf("month"),
                ],
            },
            "locale" : {
				"customRangeLabel" : "Custom",
				"daysOfWeek": [
		            "일",
		            "월",
		            "화",
		            "수",
		            "목",
		            "금",
		            "토"
		        ],
				"monthNames": [
		            "1월",
		            "2월",
		            "3월",
		            "4월",
		            "5월",
		            "6월",
		            "7월",
		            "8월",
		            "9월",
		            "10월",
		            "11월",
		            "12월"
		        ],
		        "firstDay": 0
			}
        },
        cb
    );

    cb(start, end);
});


$(function() {
    var date = moment();
	    
    function cb(date, id) {
    	
        $("#"+id+" span").html(date.format("YYYY-MM-DD"));
        
		//SingleDate Picker 사용시에는 해당 div의 id의 앞에 singleDateDiv포함
		//실제 넘어가는 데이터 영역(input hidden)에는 singleDateDiv 삭제  
		var customid = id.replace("singleDateDiv", "");
        $("#"+customid).val(date.format("YYYY-MM-DD"));
        
    }

	$(".singleDatePicker").each(function() {
		var id = this.id;
		$("#"+id).daterangepicker({
	        "singleDatePicker" : true,
			"autoApply" : true,
			"autoUpdateInput" : false,
			"customRangeLabel": "Custom",
			"locale" : {
				"format" : "YYYY-MM-DD",
				"customRangeLabel" : "Custom",
				"daysOfWeek": [
		            "일",
		            "월",
		            "화",
		            "수",
		            "목",
		            "금",
		            "토"
		        ],
				"monthNames": [
		            "1월",
		            "2월",
		            "3월",
		            "4월",
		            "5월",
		            "6월",
		            "7월",
		            "8월",
		            "9월",
		            "10월",
		            "11월",
		            "12월"
		        ],
		        "firstDay": 0
			}
	    },
			function(start) {
				date = start;
			}
		);
		
		$("#"+id).on("apply.daterangepicker", function() {
			cb(date, id);
		})

	    cb(date, id);
	})
});


function setSingleDateField(id, val) {
	$('#'+id).data('daterangepicker').setStartDate(val);
	$('#'+id).data('daterangepicker').setEndDate(val);
}

