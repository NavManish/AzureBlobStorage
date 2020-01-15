tableextension 50203 SalesBlobFileName extends "Sales Header" //MyTargetTableId
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