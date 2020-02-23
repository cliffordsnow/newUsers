select tags->'ideditor:walkthrough_started' , tags->'ideditor:walkthrough_progress', tags->'ideditor:walkthrough_completed'
from osm_changeset 
where created_at > '2020-01-01' and tags->'changeset_count; = '1' and tags->'created_by' ilike 'id 2.%' and tags->'ideditor:walkthrough_started' = 'yes';

