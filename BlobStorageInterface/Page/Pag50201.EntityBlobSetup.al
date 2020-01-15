page 50201 "Entity Blob Setup"
{

/// Referred to Blog --> https://deepanshsaini.blogspot.com/2019/04/uploading-and-downloading-file-to-azure.html

    PageType = Card;
    SourceTable = "Entity Blob Setup";
    Caption = 'Entity Blob Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Customer Setup"; "Customer Setup")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Setup';
                }

                field("Vendor Setup"; "Vendor Setup")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Setup';
                }

                field("Item Setup"; "Item Setup")
                {
                    ApplicationArea = All;
                    Caption = 'Item Setup';
                }        
                field("Employee Setup"; "Employee Setup")
                {
                    ApplicationArea = All;
                    Caption = 'Employee Setup';
                }                   
                field("Sales Setup"; "Sales Setup")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Setup';
                }  

                field("Purchase Setup"; "Purchase Setup")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Setup';
                } 

            }
        }
    }

    trigger OnOpenPage()
    begin
        InsertIfNotExists();
    end;

    local procedure InsertIfNotExists()
    begin
        If Not Get() then begin
            Init();
            Insert();
        end;
    end;
}
