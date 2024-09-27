


-- todo 导出MySQL数据库表数据，多行专一列数据
SELECT
    create_date AS '日期',
    new_user_count AS '新增用户',
    sum(if(retention_day = 1, retention_rate, 0)) AS '1天后',
    sum(if(retention_day = 2, retention_rate, 0)) AS '2天后',
    sum(if(retention_day = 3, retention_rate, 0)) AS '3天后',
    sum(if(retention_day = 4, retention_rate, 0)) AS '4天后',
    sum(if(retention_day = 5, retention_rate, 0)) AS '5天后',
    sum(if(retention_day = 6, retention_rate, 0)) AS '6天后',
    sum(if(retention_day = 7, retention_rate, 0)) AS '7天后'
FROM gmall_report.ads_user_retention
WHERE dt > DATE_SUB('2024-03-28', INTERVAL 7 DAY) AND dt <= '2024-03-28'
GROUP BY create_date, new_user_count
;


/*
2024-03-21,642,1.09,0.93,0.78,0.47,0.62,0.78,0.47
2024-03-22,691,1.74,1.74,1.30,1.24,1.16,0.87,0.00
2024-03-23,647,1.55,1.24,1.39,1.39,1.39,0.00,0.00
2024-03-24,629,2.49,1.75,1.59,1.59,0.00,0.00,0.00
2024-03-25,247,1.21,1.21,2.02,0.00,0.00,0.00,0.00
2024-03-26,241,2.49,1.66,0.00,0.00,0.00,0.00,0.00
2024-03-27,562,1.07,0.00,0.00,0.00,0.00,0.00,0.00
*/


