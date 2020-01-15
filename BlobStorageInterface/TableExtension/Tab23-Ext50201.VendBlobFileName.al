tableextension 50201 VendBlobFileName extends Vendor //MyTargetTableId
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