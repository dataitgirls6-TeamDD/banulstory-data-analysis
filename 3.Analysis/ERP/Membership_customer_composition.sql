/*등급별 고객 수*/
WITH members AS
(
  SELECT membership
  , COUNT(membership) AS membership_cnt
FROM banulstory.customers
GROUP BY membership
)

SELECT *
FROM members
ORDER BY membership_cnt DESC;



/*멤버십별 구성비 구하기*/
WITH members AS
(
  SELECT membership
  , COUNT(membership) AS membership_cnt
FROM banulstory.customers
GROUP BY membership
)


SELECT membership,
	ROUND(membership_cnt / (SELECT SUM(membership_cnt) FROM members)*100, 2) AS membership_rate
FROM members
ORDER BY 2 DESC;