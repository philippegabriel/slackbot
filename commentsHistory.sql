-- list jira issues where 'NAME', acted on a jira ticket since a given interval 
-- Using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema
select a.author,'added a',a.actiontype,'to',concat(p.pkey,'-',j.issuenum),'at',to_char(a.created,'HH24:MI:SS')
from jiraaction a, jiraissue j, project p
where a.created >= NOW() - :since::INTERVAL 
and a.issueid=j.id 
and j.project=p.id
and a.author in (:names)
order by a.created desc;
