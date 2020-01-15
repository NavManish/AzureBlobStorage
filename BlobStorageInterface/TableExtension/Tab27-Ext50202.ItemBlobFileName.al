tableextension 50202 ItemBlobFileName extends Item //MyTargetTableId
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