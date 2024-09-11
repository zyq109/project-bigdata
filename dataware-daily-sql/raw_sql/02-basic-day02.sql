
-- 创建数据库
CREATE DATABASE IF NOT EXISTS hive_sql_zg5;
-- 使用数据库
USE hive_sql_zg5 ;

-- todo: 2.1、分组
-- 1）、查询各科成绩最高和最低的分，以如下的形式显示：课程号，最高分，最低分；
SELECT
    course_id
    ,MAX(score)  as max_score
    ,MIN(score)  as min_score
FROM hive_sql_zg5.score_info
group by course_id;



-- 2）、查询每门课程有多少学生参加了考试（有考试成绩）；

SELECT
    course_id
    ,count(stu_id) as cnt_stu

FROM hive_sql_zg5.score_info
GROUP BY course_id  ;



-- 3）、查询男生、女生人数；

SELECT
    count(stu_id) cnt_stu
FROM hive_sql_zg5.student_info
GROUP BY sex;


-- todo：2.2、分组结果的条件
-- 1）、查询平均成绩大于60分的学生的学号和平均成绩；

SELECT
--     stu_id
    avg(score) as avg_score
FROM hive_sql_zg5.score_info
-- WHERE score>avg_score
GROUP BY course_id;



-- 2）、查询至少选修四门课程的学生学号；



-- 3）、查询同姓（假设每个学生姓名的第一个字为姓）的学生名单并统计同姓人数大于2的姓；



-- 4）、查询每门课程的平均成绩，结果按平均成绩升序排序，平均成绩相同时，按课程号降序排列；


-- 5）、统计参加考试人数大于等于15的学科；

