tableextension 50200 CustBlobFileName extends Customer //MyTargetTableId
{
    fields
    {
        field(50200; BlobFileName; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Blob File Name';
        }
    }
    
}