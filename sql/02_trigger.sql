CREATE OR REPLACE FUNCTION export_to_s3() 
	RETURNS TRIGGER 
AS $export_to_s3$
BEGIN
	PERFORM aws_s3.query_export_to_s3(
		'select * from sample_table', 
	   	aws_commons.create_s3_uri(
	   		'S3_BUCKET_NAME', 
	   		'test.csv', 
	   		'us-east-1'),
	   	options :='format csv, delimiter $$,$$'
	);
	RETURN NEW;
END;
$export_to_s3$ LANGUAGE plpgsql;

CREATE TRIGGER sample_table_trg
	AFTER INSERT OR DELETE OR UPDATE OR TRUNCATE
	ON sample_table
	FOR EACH STATEMENT
		EXECUTE PROCEDURE export_to_s3();
		
