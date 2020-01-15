table 50200 "Entity Blob Setup"
{
/// Referred to Blog --> https://deepanshsaini.blogspot.com/2019/04/uploading-and-downloading-file-to-azure.html
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }

        field(2; "Customer Setup"; Boolean)
        {
            Caption = 'Customer Setup';
            DataClassification = CustomerContent;

        }
        field(3; "Vendor Setup"; Boolean)
        {
            Caption = 'Vendor Setup';
            DataClassification = CustomerContent;

        }
        field(4; "Item Setup"; Boolean)
        {
            Caption = 'Item Setup';
            DataClassification = CustomerContent;

        }
        field(5; "Employee Setup"; Boolean)
        {
            Caption = 'Employee Setup';
            DataClassification = CustomerContent;

        }
        field(6; "Sales Setup"; Boolean)
        {
            Caption = 'Sales Setup';
            DataClassification = CustomerContent;

        }
        field(7; "Purchase Setup"; Boolean)
        {
            Caption = 'Purchase Setup';
            DataClassification = CustomerContent;

        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

}