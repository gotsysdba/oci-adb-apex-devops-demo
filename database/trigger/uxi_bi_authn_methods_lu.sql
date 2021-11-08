-- liquibase formatted sql

-- changeset john:Initial context:demo endDelimiter="/"
CREATE OR REPLACE EDITIONABLE TRIGGER "UXI_BI_AUTHN_METHODS_LU" 
  before insert on "UXI_AUTHN_METHODS_LU"               
  for each row  
begin   
  if :NEW."ID" is null then 
    select "UXI_AUTHN_METHODS_LU_SEQ".nextval into :NEW."ID" from sys.dual; 
  end if; 
end;
/