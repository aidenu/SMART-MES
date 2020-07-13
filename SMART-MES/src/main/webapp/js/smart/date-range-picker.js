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
