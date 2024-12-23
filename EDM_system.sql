PGDMP  ,                
    |            ERD_SystemDb    16.3    16.3 V               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    40960    ERD_SystemDb    DATABASE     �   CREATE DATABASE "ERD_SystemDb" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE "ERD_SystemDb";
                postgres    false                        2615    49152 	   workspace    SCHEMA        CREATE SCHEMA workspace;
    DROP SCHEMA workspace;
                postgres    false            Z           1247    49270 	   user_role    TYPE     X   CREATE TYPE workspace.user_role AS ENUM (
    'admin',
    'employee',
    'manager'
);
    DROP TYPE workspace.user_role;
    	   workspace          postgres    false    6            �            1255    49385    current_user_id()    FUNCTION     o  CREATE FUNCTION workspace.current_user_id() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    user_id INT;
BEGIN
    SELECT u.user_id INTO user_id
    FROM workspace.users u
    WHERE u.username = session_user;  -- Используем session_user для получения имени текущего пользователя

    RETURN user_id;
END;
$$;
 +   DROP FUNCTION workspace.current_user_id();
    	   workspace          postgres    false    6            �            1255    49373    log_user_activity()    FUNCTION     =  CREATE FUNCTION workspace.log_user_activity() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO activity_log (user_id, action) 
    VALUES (NEW.user_id, TG_OP || ' on ' || TG_TABLE_NAME || ' for ID ' || COALESCE(NEW.file_id, NEW.folder_id) || ' at ' || CURRENT_TIMESTAMP);
    RETURN NEW;
END;
$$;
 -   DROP FUNCTION workspace.log_user_activity();
    	   workspace          postgres    false    6            �            1259    49349    activity_log    TABLE     �   CREATE TABLE workspace.activity_log (
    log_id integer NOT NULL,
    user_id integer,
    action character varying(255) NOT NULL,
    action_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
 #   DROP TABLE workspace.activity_log;
    	   workspace         heap    postgres    false    6                       0    0    TABLE activity_log    ACL     �   GRANT ALL ON TABLE workspace.activity_log TO admin_role;
GRANT SELECT,INSERT,UPDATE ON TABLE workspace.activity_log TO employee_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE workspace.activity_log TO manager_role;
       	   workspace          postgres    false    229            �            1259    49348    activity_log_log_id_seq    SEQUENCE     �   CREATE SEQUENCE workspace.activity_log_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE workspace.activity_log_log_id_seq;
    	   workspace          postgres    false    229    6                       0    0    activity_log_log_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE workspace.activity_log_log_id_seq OWNED BY workspace.activity_log.log_id;
       	   workspace          postgres    false    228            �            1259    49362    contact_info    TABLE     �   CREATE TABLE workspace.contact_info (
    contact_id integer NOT NULL,
    user_id integer,
    phone character varying(15),
    address character varying(255),
    workplace character varying(100)
);
 #   DROP TABLE workspace.contact_info;
    	   workspace         heap    postgres    false    6                       0    0    TABLE contact_info    ACL     �   GRANT ALL ON TABLE workspace.contact_info TO admin_role;
GRANT SELECT,INSERT,UPDATE ON TABLE workspace.contact_info TO employee_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE workspace.contact_info TO manager_role;
       	   workspace          postgres    false    231            �            1259    49361    contact_info_contact_id_seq    SEQUENCE     �   CREATE SEQUENCE workspace.contact_info_contact_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE workspace.contact_info_contact_id_seq;
    	   workspace          postgres    false    231    6                       0    0    contact_info_contact_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE workspace.contact_info_contact_id_seq OWNED BY workspace.contact_info.contact_id;
       	   workspace          postgres    false    230            �            1259    49295 
   file_types    TABLE     w   CREATE TABLE workspace.file_types (
    file_type_id integer NOT NULL,
    type_name character varying(50) NOT NULL
);
 !   DROP TABLE workspace.file_types;
    	   workspace         heap    postgres    false    6                       0    0    TABLE file_types    ACL     �   GRANT ALL ON TABLE workspace.file_types TO admin_role;
GRANT SELECT,INSERT,UPDATE ON TABLE workspace.file_types TO employee_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE workspace.file_types TO manager_role;
       	   workspace          postgres    false    221            �            1259    49294    file_types_file_type_id_seq    SEQUENCE     �   CREATE SEQUENCE workspace.file_types_file_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE workspace.file_types_file_type_id_seq;
    	   workspace          postgres    false    221    6                       0    0    file_types_file_type_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE workspace.file_types_file_type_id_seq OWNED BY workspace.file_types.file_type_id;
       	   workspace          postgres    false    220            �            1259    49326    files    TABLE     7  CREATE TABLE workspace.files (
    file_id integer NOT NULL,
    file_name character varying(100) NOT NULL,
    file_type_id integer,
    folder_id integer,
    user_id integer,
    upload_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE ONLY workspace.files FORCE ROW LEVEL SECURITY;
    DROP TABLE workspace.files;
    	   workspace         heap    postgres    false    6                       0    0    TABLE files    ACL     �   GRANT ALL ON TABLE workspace.files TO admin_role;
GRANT SELECT,INSERT,UPDATE ON TABLE workspace.files TO employee_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE workspace.files TO manager_role;
       	   workspace          postgres    false    227            �            1259    49325    files_file_id_seq    SEQUENCE     �   CREATE SEQUENCE workspace.files_file_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE workspace.files_file_id_seq;
    	   workspace          postgres    false    6    227                       0    0    files_file_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE workspace.files_file_id_seq OWNED BY workspace.files.file_id;
       	   workspace          postgres    false    226            �            1259    49314    folders    TABLE     �   CREATE TABLE workspace.folders (
    folder_id integer NOT NULL,
    folder_name character varying(100) NOT NULL,
    user_id integer
);

ALTER TABLE ONLY workspace.folders FORCE ROW LEVEL SECURITY;
    DROP TABLE workspace.folders;
    	   workspace         heap    postgres    false    6                       0    0    TABLE folders    ACL     �   GRANT ALL ON TABLE workspace.folders TO admin_role;
GRANT SELECT,INSERT,UPDATE ON TABLE workspace.folders TO employee_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE workspace.folders TO manager_role;
       	   workspace          postgres    false    225            �            1259    49313    folders_folder_id_seq    SEQUENCE     �   CREATE SEQUENCE workspace.folders_folder_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE workspace.folders_folder_id_seq;
    	   workspace          postgres    false    225    6                       0    0    folders_folder_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE workspace.folders_folder_id_seq OWNED BY workspace.folders.folder_id;
       	   workspace          postgres    false    224            �            1259    49302    limits    TABLE     �   CREATE TABLE workspace.limits (
    limit_id integer NOT NULL,
    user_id integer,
    file_limit integer,
    storage_limit integer
);
    DROP TABLE workspace.limits;
    	   workspace         heap    postgres    false    6                       0    0    TABLE limits    ACL     �   GRANT ALL ON TABLE workspace.limits TO admin_role;
GRANT SELECT,INSERT,UPDATE ON TABLE workspace.limits TO employee_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE workspace.limits TO manager_role;
       	   workspace          postgres    false    223            �            1259    49301    limits_limit_id_seq    SEQUENCE     �   CREATE SEQUENCE workspace.limits_limit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE workspace.limits_limit_id_seq;
    	   workspace          postgres    false    223    6                       0    0    limits_limit_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE workspace.limits_limit_id_seq OWNED BY workspace.limits.limit_id;
       	   workspace          postgres    false    222            �            1259    49288    permissions    TABLE        CREATE TABLE workspace.permissions (
    permission_id integer NOT NULL,
    permission_name character varying(50) NOT NULL
);
 "   DROP TABLE workspace.permissions;
    	   workspace         heap    postgres    false    6                       0    0    TABLE permissions    ACL     �   GRANT ALL ON TABLE workspace.permissions TO admin_role;
GRANT SELECT,INSERT,UPDATE ON TABLE workspace.permissions TO employee_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE workspace.permissions TO manager_role;
       	   workspace          postgres    false    219            �            1259    49287    permissions_permission_id_seq    SEQUENCE     �   CREATE SEQUENCE workspace.permissions_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE workspace.permissions_permission_id_seq;
    	   workspace          postgres    false    6    219                       0    0    permissions_permission_id_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE workspace.permissions_permission_id_seq OWNED BY workspace.permissions.permission_id;
       	   workspace          postgres    false    218            �            1259    49278    users    TABLE       CREATE TABLE workspace.users (
    user_id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    email character varying(100) NOT NULL,
    role workspace.user_role DEFAULT 'employee'::workspace.user_role
);
    DROP TABLE workspace.users;
    	   workspace         heap    postgres    false    858    858    6                        0    0    TABLE users    ACL     �   GRANT ALL ON TABLE workspace.users TO admin_role;
GRANT SELECT,INSERT,UPDATE ON TABLE workspace.users TO employee_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE workspace.users TO manager_role;
       	   workspace          postgres    false    217            �            1259    49277    users_user_id_seq    SEQUENCE     �   CREATE SEQUENCE workspace.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE workspace.users_user_id_seq;
    	   workspace          postgres    false    6    217            !           0    0    users_user_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE workspace.users_user_id_seq OWNED BY workspace.users.user_id;
       	   workspace          postgres    false    216            K           2604    49352    activity_log log_id    DEFAULT     �   ALTER TABLE ONLY workspace.activity_log ALTER COLUMN log_id SET DEFAULT nextval('workspace.activity_log_log_id_seq'::regclass);
 E   ALTER TABLE workspace.activity_log ALTER COLUMN log_id DROP DEFAULT;
    	   workspace          postgres    false    228    229    229            M           2604    49365    contact_info contact_id    DEFAULT     �   ALTER TABLE ONLY workspace.contact_info ALTER COLUMN contact_id SET DEFAULT nextval('workspace.contact_info_contact_id_seq'::regclass);
 I   ALTER TABLE workspace.contact_info ALTER COLUMN contact_id DROP DEFAULT;
    	   workspace          postgres    false    231    230    231            F           2604    49298    file_types file_type_id    DEFAULT     �   ALTER TABLE ONLY workspace.file_types ALTER COLUMN file_type_id SET DEFAULT nextval('workspace.file_types_file_type_id_seq'::regclass);
 I   ALTER TABLE workspace.file_types ALTER COLUMN file_type_id DROP DEFAULT;
    	   workspace          postgres    false    220    221    221            I           2604    49329    files file_id    DEFAULT     t   ALTER TABLE ONLY workspace.files ALTER COLUMN file_id SET DEFAULT nextval('workspace.files_file_id_seq'::regclass);
 ?   ALTER TABLE workspace.files ALTER COLUMN file_id DROP DEFAULT;
    	   workspace          postgres    false    226    227    227            H           2604    49317    folders folder_id    DEFAULT     |   ALTER TABLE ONLY workspace.folders ALTER COLUMN folder_id SET DEFAULT nextval('workspace.folders_folder_id_seq'::regclass);
 C   ALTER TABLE workspace.folders ALTER COLUMN folder_id DROP DEFAULT;
    	   workspace          postgres    false    224    225    225            G           2604    49305    limits limit_id    DEFAULT     x   ALTER TABLE ONLY workspace.limits ALTER COLUMN limit_id SET DEFAULT nextval('workspace.limits_limit_id_seq'::regclass);
 A   ALTER TABLE workspace.limits ALTER COLUMN limit_id DROP DEFAULT;
    	   workspace          postgres    false    223    222    223            E           2604    49291    permissions permission_id    DEFAULT     �   ALTER TABLE ONLY workspace.permissions ALTER COLUMN permission_id SET DEFAULT nextval('workspace.permissions_permission_id_seq'::regclass);
 K   ALTER TABLE workspace.permissions ALTER COLUMN permission_id DROP DEFAULT;
    	   workspace          postgres    false    218    219    219            C           2604    49281    users user_id    DEFAULT     t   ALTER TABLE ONLY workspace.users ALTER COLUMN user_id SET DEFAULT nextval('workspace.users_user_id_seq'::regclass);
 ?   ALTER TABLE workspace.users ALTER COLUMN user_id DROP DEFAULT;
    	   workspace          postgres    false    216    217    217            	          0    49349    activity_log 
   TABLE DATA           O   COPY workspace.activity_log (log_id, user_id, action, action_date) FROM stdin;
 	   workspace          postgres    false    229   j                 0    49362    contact_info 
   TABLE DATA           Y   COPY workspace.contact_info (contact_id, user_id, phone, address, workplace) FROM stdin;
 	   workspace          postgres    false    231   %j                 0    49295 
   file_types 
   TABLE DATA           @   COPY workspace.file_types (file_type_id, type_name) FROM stdin;
 	   workspace          postgres    false    221   Bj                 0    49326    files 
   TABLE DATA           e   COPY workspace.files (file_id, file_name, file_type_id, folder_id, user_id, upload_date) FROM stdin;
 	   workspace          postgres    false    227   _j                 0    49314    folders 
   TABLE DATA           E   COPY workspace.folders (folder_id, folder_name, user_id) FROM stdin;
 	   workspace          postgres    false    225   |j                 0    49302    limits 
   TABLE DATA           Q   COPY workspace.limits (limit_id, user_id, file_limit, storage_limit) FROM stdin;
 	   workspace          postgres    false    223   �j       �          0    49288    permissions 
   TABLE DATA           H   COPY workspace.permissions (permission_id, permission_name) FROM stdin;
 	   workspace          postgres    false    219   �j       �          0    49278    users 
   TABLE DATA           L   COPY workspace.users (user_id, username, password, email, role) FROM stdin;
 	   workspace          postgres    false    217   �j       "           0    0    activity_log_log_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('workspace.activity_log_log_id_seq', 1, false);
       	   workspace          postgres    false    228            #           0    0    contact_info_contact_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('workspace.contact_info_contact_id_seq', 1, false);
       	   workspace          postgres    false    230            $           0    0    file_types_file_type_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('workspace.file_types_file_type_id_seq', 1, false);
       	   workspace          postgres    false    220            %           0    0    files_file_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('workspace.files_file_id_seq', 1, false);
       	   workspace          postgres    false    226            &           0    0    folders_folder_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('workspace.folders_folder_id_seq', 1, false);
       	   workspace          postgres    false    224            '           0    0    limits_limit_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('workspace.limits_limit_id_seq', 1, false);
       	   workspace          postgres    false    222            (           0    0    permissions_permission_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('workspace.permissions_permission_id_seq', 1, false);
       	   workspace          postgres    false    218            )           0    0    users_user_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('workspace.users_user_id_seq', 3, true);
       	   workspace          postgres    false    216            ]           2606    49355    activity_log activity_log_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY workspace.activity_log
    ADD CONSTRAINT activity_log_pkey PRIMARY KEY (log_id);
 K   ALTER TABLE ONLY workspace.activity_log DROP CONSTRAINT activity_log_pkey;
    	   workspace            postgres    false    229            _           2606    49367    contact_info contact_info_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY workspace.contact_info
    ADD CONSTRAINT contact_info_pkey PRIMARY KEY (contact_id);
 K   ALTER TABLE ONLY workspace.contact_info DROP CONSTRAINT contact_info_pkey;
    	   workspace            postgres    false    231            U           2606    49300    file_types file_types_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY workspace.file_types
    ADD CONSTRAINT file_types_pkey PRIMARY KEY (file_type_id);
 G   ALTER TABLE ONLY workspace.file_types DROP CONSTRAINT file_types_pkey;
    	   workspace            postgres    false    221            [           2606    49332    files files_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY workspace.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (file_id);
 =   ALTER TABLE ONLY workspace.files DROP CONSTRAINT files_pkey;
    	   workspace            postgres    false    227            Y           2606    49319    folders folders_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY workspace.folders
    ADD CONSTRAINT folders_pkey PRIMARY KEY (folder_id);
 A   ALTER TABLE ONLY workspace.folders DROP CONSTRAINT folders_pkey;
    	   workspace            postgres    false    225            W           2606    49307    limits limits_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY workspace.limits
    ADD CONSTRAINT limits_pkey PRIMARY KEY (limit_id);
 ?   ALTER TABLE ONLY workspace.limits DROP CONSTRAINT limits_pkey;
    	   workspace            postgres    false    223            S           2606    49293    permissions permissions_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY workspace.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (permission_id);
 I   ALTER TABLE ONLY workspace.permissions DROP CONSTRAINT permissions_pkey;
    	   workspace            postgres    false    219            O           2606    49286    users users_email_key 
   CONSTRAINT     T   ALTER TABLE ONLY workspace.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 B   ALTER TABLE ONLY workspace.users DROP CONSTRAINT users_email_key;
    	   workspace            postgres    false    217            Q           2606    49284    users users_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY workspace.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 =   ALTER TABLE ONLY workspace.users DROP CONSTRAINT users_pkey;
    	   workspace            postgres    false    217            h           2620    49374    files files_activity_trigger    TRIGGER     �   CREATE TRIGGER files_activity_trigger AFTER INSERT OR DELETE OR UPDATE ON workspace.files FOR EACH ROW EXECUTE FUNCTION workspace.log_user_activity();
 8   DROP TRIGGER files_activity_trigger ON workspace.files;
    	   workspace          postgres    false    232    227            g           2620    49375     folders folders_activity_trigger    TRIGGER     �   CREATE TRIGGER folders_activity_trigger AFTER INSERT OR DELETE OR UPDATE ON workspace.folders FOR EACH ROW EXECUTE FUNCTION workspace.log_user_activity();
 <   DROP TRIGGER folders_activity_trigger ON workspace.folders;
    	   workspace          postgres    false    225    232            e           2606    49356 &   activity_log activity_log_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY workspace.activity_log
    ADD CONSTRAINT activity_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES workspace.users(user_id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY workspace.activity_log DROP CONSTRAINT activity_log_user_id_fkey;
    	   workspace          postgres    false    229    4689    217            f           2606    49368 &   contact_info contact_info_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY workspace.contact_info
    ADD CONSTRAINT contact_info_user_id_fkey FOREIGN KEY (user_id) REFERENCES workspace.users(user_id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY workspace.contact_info DROP CONSTRAINT contact_info_user_id_fkey;
    	   workspace          postgres    false    4689    231    217            b           2606    49333    files files_file_type_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY workspace.files
    ADD CONSTRAINT files_file_type_id_fkey FOREIGN KEY (file_type_id) REFERENCES workspace.file_types(file_type_id) ON DELETE SET NULL;
 J   ALTER TABLE ONLY workspace.files DROP CONSTRAINT files_file_type_id_fkey;
    	   workspace          postgres    false    221    227    4693            c           2606    49338    files files_folder_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY workspace.files
    ADD CONSTRAINT files_folder_id_fkey FOREIGN KEY (folder_id) REFERENCES workspace.folders(folder_id) ON DELETE SET NULL;
 G   ALTER TABLE ONLY workspace.files DROP CONSTRAINT files_folder_id_fkey;
    	   workspace          postgres    false    4697    227    225            d           2606    49343    files files_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY workspace.files
    ADD CONSTRAINT files_user_id_fkey FOREIGN KEY (user_id) REFERENCES workspace.users(user_id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY workspace.files DROP CONSTRAINT files_user_id_fkey;
    	   workspace          postgres    false    217    4689    227            a           2606    49320    folders folders_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY workspace.folders
    ADD CONSTRAINT folders_user_id_fkey FOREIGN KEY (user_id) REFERENCES workspace.users(user_id) ON DELETE CASCADE;
 I   ALTER TABLE ONLY workspace.folders DROP CONSTRAINT folders_user_id_fkey;
    	   workspace          postgres    false    217    225    4689            `           2606    49308    limits limits_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY workspace.limits
    ADD CONSTRAINT limits_user_id_fkey FOREIGN KEY (user_id) REFERENCES workspace.users(user_id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY workspace.limits DROP CONSTRAINT limits_user_id_fkey;
    	   workspace          postgres    false    217    223    4689            �           3256    49386    files file_access_policy    POLICY     e   CREATE POLICY file_access_policy ON workspace.files USING ((user_id = workspace.current_user_id()));
 3   DROP POLICY file_access_policy ON workspace.files;
    	   workspace          postgres    false    227    233    227            �           0    49326    files    ROW SECURITY     6   ALTER TABLE workspace.files ENABLE ROW LEVEL SECURITY;       	   workspace          postgres    false    227            �           3256    49387    folders folder_access_policy    POLICY     i   CREATE POLICY folder_access_policy ON workspace.folders USING ((user_id = workspace.current_user_id()));
 7   DROP POLICY folder_access_policy ON workspace.folders;
    	   workspace          postgres    false    225    233    225            �           0    49314    folders    ROW SECURITY     8   ALTER TABLE workspace.folders ENABLE ROW LEVEL SECURITY;       	   workspace          postgres    false    225            	      x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �      �      x������ � �      �   b   x�e�Q
� D�wX� ������Gu�� ��7o�e��<;]��#W���W>IJ��fr�`���v6?)_̸��TcO��
%ڹ�6!��|8Z     