
-- 创建数据库
CREATE DATABASE IF NOT EXISTS hive_sql_zg5;
-- 使用数据库
USE hive_sql_zg5 ;

-- todo: 3.1、查询结果排序&分组指定条件
-- 1）、查询学生的总成绩并按照总成绩降序排序；

SELECT
    stu_id
    ,SUM(score) AS sum_score
FROM hive_sql_zg5.score_info
GROUP BY stu_id
ORDER BY sum_score DESC

;




-- 2）、按如下格式显示学生的语文、数学、英语三科成绩，没有成绩的输出为0，按照学生的有效平均成绩降序显示；
-- 学生id 语文 数学 英语   有效课程数 有效平均成绩
-- 001    98   80  60    3       83
-- 002    85   90  0     2       87.5

SELECT
    stu_id
    ,AVG(score)  as avg_score

FROM hive_sql_zg5.score_info
GROUP BY stu_id
;

SELECT
    stu_id
     ,course_name
     ,score
FROM hive_sql_zg5.score_info
LEFT JOIN hive_sql_zg5.course_info ci on score_info.course_id = ci.course_id
GROUP BY stu_id,course_name,score

;

SELECT
    stu_id,
    CONCAT_WS(',', COLLECT_LIST(course_name)) AS course_names,
    CONCAT_WS(',', COLLECT_LIST(CAST(score AS STRING))) AS scores
FROM hive_sql_zg5.score_info
         LEFT JOIN hive_sql_zg5.course_info ci ON score_info.course_id = ci.course_id
GROUP BY stu_id;


SELECT
    stu_id,
    MAX(CASE WHEN course_name = '语文' THEN score ELSE NULL END) AS 语文,
        MAX(CASE WHEN course_name = '数学' THEN score ELSE NULL END) AS 数学,
        MAX(CASE WHEN course_name = '英语' THEN score ELSE NULL END) AS 英语
            FROM hive_sql_zg5.score_info
    LEFT JOIN hive_sql_zg5.course_info ci ON score_info.course_id = ci.course_id
GROUP BY stu_id;

-- 3）、查询一共参加三门课程且其中一门为语文课程的学生的id和姓名；


-- todo：3.2、子查询
-- 1）、查询所有课程成绩均小于60分的学生的学号、姓名；

-- 2）、查询没有学全所有课的学生的学号、姓名；


-- 3）、查询出只选修了三门课程的全部学生的学号和姓名；



