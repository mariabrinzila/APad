DROP TABLE public.note

CREATE TABLE public.note 
(
	note_id SERIAL PRIMARY KEY, /* SERIAl => se autoincrementeaza */
	title VARCHAR(50) NOT NULL,
	category VARCHAR(50) NOT NULL,
	note_content VARCHAR(10000)
)

INSERT INTO public.note (title, category, note_content)
	VALUES ('Test', 'Personal', 'ABCDFEF');

INSERT INTO public.note (title, category, note_content)
	VALUES ('Test1', 'Personal', 'fgdfhg');
	
INSERT INTO public.note (title, category, note_content)
	VALUES ('Test2', 'Gym', 'leg workout');
	
SELECT * FROM public.note;
