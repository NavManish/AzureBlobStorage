tableextension 50205 EmployeeBlobFileName extends Employee //MyTargetTableId
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