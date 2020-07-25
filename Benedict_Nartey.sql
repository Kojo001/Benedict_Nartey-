	/*QUESTION ONE(1)
	Finding how many users WAVE has*/
SELECT COUNT (*) FROM users;


       /*QUESTION TWO(2)
       Finding how many transfers that have been sent in 'CFA'*/
SELECT COUNT(*) FROM transfers  WHERE send_amount_currency = 'CFA';


     /*QUESTION THREE(3)
     Finding how many 'different users' sent a transfer in 'CFA'*/
SELECT COUNT (DISTINCT u_id) FROM transfers WHERE send_amount_currency = 'CFA';


    /*QUESTION FOUR(4)
    Finding how many agent transactions recorded in 2018 and grouping them by months*/
SELECT TO_CHAR (when_created, 'Month')
AS "Month", COUNT (atx_id) 
FROM agent_transactions 
WHERE EXTRACT (YEAR FROM when_created) = 2018 
GROUP BY "Month";



   /*QUESTION FIVE(5)
   Finding the number wave agents who were  'net depositors' as against 'net withdrawers' 
   over the course of last week*/
SELECT SUM (CASE WHEN amount > 0 THEN amount ELSE 0 END) AS withdrawal,
SUM (CASE WHEN amount < 0 THEN amount ELSE 0 END) AS deposit,
CASE WHEN ((SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END)) > ((SUM( CASE WHEN amount < 0 THEN amount ELSE 0 END))) * -1)
THEN 'withdrawer'
ELSE 'depositor' END AS agent_status,
COUNT (*) FROM agent_transactions
WHERE when_created BETWEEN (now() - '1 WEEK'::INTERVAL) AND now();


   /*QUESTION SIX(6)
    Finding volume of agent transactions create in the last week grouped by city*/
SELECT agents.city,
COUNT (amount) FROM agent_transactions
INNER JOIN agents
ON agents.agent_id = agent_transactions.agent_id
WHERE agent_transactions.when_created > current_date - interval '7 days'
GROUP BY agents.city;


   /*QUESTION SEVEN (7)
     Finding transactions volume by country with columns, country city and volume*/
SELECT COUNT (atx.amount) AS "atx volume",
    COUNT (ag.city) AS "City",
	COUNT (ag.country) AS "Country"
	FROM agent_transactions AS atx INNER JOIN agents AS ag 
	ON atx.atx_id = ag.agent_id
	GROUP BY ag.country;


   /* ALTERNATIVE QUESTION 7
   Finding transactions volume by country with columns, country city and volume*/
SELECT COUNT (atx.amount) AS "atx volume",
    COUNT (agents.city) AS "City",
	COUNT (agents.country) AS "Country"
	FROM agent_transactions AS atx INNER JOIN agents AS agents 
	ON atx.atx_id = agents.agent_id
	GROUP BY agents.country;
	


   /*QUESTION EIGHT(8)
    Building a send volume by country and kind table 
    Finding the total volume of transfers sent in the past week grouped by country and transfer kind*/
SELECT transfers.kind AS Kind, wallets.ledger_location AS Country,
  SUM (transfers.send_amount_scalar) AS Volume FROM transfers
  INNER JOIN wallets ON transfers.source_wallet_id = wallets.wallet_id
  WHERE (transfers.when_created > (NOW() - INTERVAL '1 week'))
  GROUP BY wallets.ledger_location, transfers.kind;


   /*QUESTION NINE(9)
   Adding Column for transaction count and number of uniqe senders to the send volume by country and kind table 
   and grouped by country and transfer kind*/
SELECT COUNT (transfers.source_wallet_id) AS Unique_Senders,
   COUNT (transfer_id) AS Transaction_Count, transfers.kind AS Transfer_kind, wallets.ledger_location AS Country,
   SUM (transfers.send_amount_scalar) AS Volume 
   FROM transfers
   INNER JOIN wallets ON transfers.source_wallet_id = wallets.wallet_id
   WHERE (transfers.when_created > (NOW() - INTERVAL '1 week'))
   GROUP BY wallets.ledger_location, transfers.kind;
    


   /*QUESTION TEN(10)
    Finding the wallet type that have sent more than 10000000 CFA in transfer in the last month
    and how much they sent*/
SELECT tn.send_amount_scalar,tn.source_wallet_id,w.wallet_id
FROM transfers AS tn INNER JOIN wallets AS w ON tn.transfer_id = w.wallet_id
WHERE tn.send_amount_scalar > 10000000
AND (tn.send_amount_currency = 'CFA' AND tn.when_created> CURRENT_DATE-INTERVAL '1 month')



   /* ALTERNATIVE QUESTION TEN(10)
    Finding the wallet type that have sent more than 10000000 CFA in transfer in the last month
    and how much they sent*/
SELECT source_wallet_id, send_amount_scalar FROM transfers
WHERE send_amount_currency = 'CFA'
AND (send_amount_scalar > 10000000)
AND (transfers.when_created > (NOW() - INTERVAL '1 month'));














