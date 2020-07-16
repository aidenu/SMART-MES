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
        },
        cb
    );

    cb(start, end);
});


$(function () {
    var date = moment();
	
    function cb(date, id) {
        $("#"+id+" span").html(
            date.format("YYYY-MM-DD")
        );
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
			"locale" : {
				format: "YYYY-MM-DD"
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
