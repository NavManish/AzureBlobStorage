page 50200 "Azure Blob Storage"
{

/// Referred to Blog --> https://deepanshsaini.blogspot.com/2019/04/uploading-and-downloading-file-to-azure.html
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Azure Blob Storage';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(EntityTypeVar; EntityTypeVar)
                {
                    ApplicationArea = All;
                    Caption = 'Entity Type';
                    trigger OnValidate()
                    begin
                        SetPageFilters();
                    end;
                }
                field(DocType; DocType)
                {
                    ApplicationArea = All;
                    Caption = 'Document Type';
                    Enabled = doctypeEditable;
                }

                field(DocNo; DocNo)
                {
                    ApplicationArea = All;
                    Caption = 'No.';

                    trigger OnValidate()
                    begin
                        ValidateEntityNo();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        SetEntityLookup();
                    end;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Download)
            {
                ApplicationArea = All;
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Download Blob';
                trigger OnAction()
                begin
                    DownloadBlobContent();
                end;
            }
            action(Upload)
            {
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Upload Blob';
                trigger OnAction()
                begin
                    UploadBlobContent();
                end;
            }
        }
    }

    var
        EBS: Record "Entity Blob Setup";
        EntityTypeVar: Option Customer,Vendor,Item,Employee,Sales,Purchase;
        DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order";
        DocNo: Code[20];
        doctypeEditable: Boolean;

    local procedure SetPageFilters()
    begin
        Clear(DocType);
        Clear(DocNo);
        SetPageFieldEditable();
        CurrPage.Update(false);
    end;

    local procedure GetEBSSetup()
    begin
        EBS.Get();
    end;

    local procedure SetPageFieldEditable()
    begin
        if EntityTypeVar in [EntityTypeVar::Sales, EntityTypeVar::Purchase] then
            doctypeEditable := true
        else
            doctypeEditable := false;
    end;

    local procedure ValidateEntityNo()
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        Item: Record Item;
        Employee: Record Employee;
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
    begin
        Case EntityTypeVar of

            EntityTypeVar::Customer:
                begin
                    if not EBS."Customer Setup" then
                        Error('Please enable Customer Setup in Entity Blob Setup');
                    Customer.get(Docno);
                end;
            EntityTypeVar::Vendor:
                begin
                    if not EBS."Vendor Setup" then
                        Error('Please enable Vendor Setup in Entity Blob Setup');
                    Vendor.get(Docno);
                end;

            EntityTypeVar::Item:
                begin
                    if not EBS."Item Setup" then
                        Error('Please enable Item Setup in Entity Blob Setup');
                    Item.Get(DocNo);
                end;

            EntityTypeVar::Employee:
                begin
                    if not EBS."Employee Setup" then
                        Error('Please enable Employee Setup in Entity Blob Setup');
                    Employee.Get(DocNo);
                end;

            EntityTypeVar::Sales:
                begin
                    if not EBS."Sales Setup" then
                        Error('Please enable Sales Setup in Entity Blob Setup');
                    SalesHeader.get(DocType, DocNo);
                end;

            EntityTypeVar::Purchase:
                begin
                    if not EBS."Purchase Setup" then
                        Error('Please enable Purchase Setup in Entity Blob Setup');
                    PurchHeader.get(DocType, DocNo);
                end;
        end;
    end;

    local procedure SetEntityLookup()
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        Item: Record Item;
        Employee: Record Employee;
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
    begin
        Case EntityTypeVar of

            EntityTypeVar::Customer:
                begin
                    if not EBS."Customer Setup" then
                        Error('Please enable Customer Setup in Entity Blob Setup');

                    Customer.Reset();
                    if Page.RunModal(0, Customer) = Action::LookupOK then
                        DocNo := Customer."No.";
                end;
            EntityTypeVar::Vendor:
                begin

                    if not EBS."Vendor Setup" then
                        Error('Please enable Vendor Setup in Entity Blob Setup');

                    Vendor.Reset();
                    if Page.RunModal(0, Vendor) = Action::LookupOK then
                        DocNo := Vendor."No.";
                end;

            EntityTypeVar::Item:
                begin

                    if not EBS."Item Setup" then
                        Error('Please enable Item Setup in Entity Blob Setup');

                    Item.Reset();
                    if Page.RunModal(0, Item) = Action::LookupOK then
                        DocNo := Item."No.";
                end;
            EntityTypeVar::Employee:
                begin

                    if not EBS."Employee Setup" then
                        Error('Please enable Employee Setup in Entity Blob Setup');

                    Employee.Reset();
                    if Page.RunModal(0, Employee) = Action::LookupOK then
                        DocNo := Employee."No.";
                end;

            EntityTypeVar::Sales:
                begin
                    if not EBS."Sales Setup" then
                        Error('Please enable Sales Setup in Entity Blob Setup');

                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", DocType);
                    if Page.RunModal(0, SalesHeader) = Action::LookupOK then
                        DocNo := SalesHeader."No.";
                end;

            EntityTypeVar::Purchase:
                begin
                    if not EBS."Purchase Setup" then
                        Error('Please enable Purchase Setup in Entity Blob Setup');

                    PurchHeader.Reset();
                    PurchHeader.SetRange("Document Type", DocType);
                    if Page.RunModal(0, PurchHeader) = Action::LookupOK then
                        DocNo := PurchHeader."No.";
                end;
        end;
    end;

    local procedure UploadBlobContent()
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        Item: Record Item;
        Employee: Record Employee;
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        AzureMgt: Codeunit "Azure Mgt.";
        FileName: Text[250];
    begin
        case EntityTypeVar of
            EntityTypeVar::Customer:
                begin
                    if not EBS."Customer Setup" then
                        Error('Please enable Customer Setup in Entity Blob Setup');
                    Customer.Get(DocNo);
                    FileName := 'Customer-' + Customer."No.";
                    AzureMgt.UploadFile(FileName);
                    if FileName <> '' then begin
                        Customer.BlobFileName := FileName;
                        Customer.Modify();
                    end;
                end;
            EntityTypeVar::Vendor:
                begin
                    if not EBS."Vendor Setup" then
                        Error('Please enable Vendor Setup in Entity Blob Setup');
                    Vendor.Get(DocNo);
                    FileName := 'Vendor-' + Vendor."No.";
                    AzureMgt.UploadFile(FileName);
                    if FileName <> '' then begin
                        Vendor.BlobFileName := FileName;
                        Vendor.Modify();
                    end;
                end;

            EntityTypeVar::Item:
                begin
                    if not EBS."Item Setup" then
                        Error('Please enable Item Setup in Entity Blob Setup');
                    Item.Get(DocNo);
                    FileName := 'Item-' + Item."No.";
                    AzureMgt.UploadFile(FileName);
                    if FileName <> '' then begin
                        Item.BlobFileName := FileName;
                        Item.Modify();
                    end;
                end;
            EntityTypeVar::Employee:
                begin
                    if not EBS."Employee Setup" then
                        Error('Please enable Employee Setup in Entity Blob Setup');
                    Employee.Get(DocNo);
                    FileName := 'Employee-' + Employee."No.";
                    AzureMgt.UploadFile(FileName);
                    if FileName <> '' then begin
                        Employee.BlobFileName := FileName;
                        Employee.Modify();
                    end;
                end;

            EntityTypeVar::Sales:
                begin
                    if not EBS."Sales Setup" then
                        Error('Please enable Sales Setup in Entity Blob Setup');
                    if SalesHeader.get(DocType, DocNo) then begin
                        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Blanket Order" then
                            FileName := 'SBO-' + SalesHeader."No.";
                        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then
                            FileName := 'SCRMemo-' + SalesHeader."No.";
                        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
                            FileName := 'SInv-' + SalesHeader."No.";
                        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
                            FileName := 'SO-' + SalesHeader."No.";
                        if SalesHeader."Document Type" = SalesHeader."Document Type"::Quote then
                            FileName := 'SQ-' + SalesHeader."No.";
                        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order" then
                            FileName := 'SRetOrder-' + SalesHeader."No.";
                        AzureMgt.UploadFile(FileName);
                        if FileName <> '' then begin
                            SalesHeader.BlobFileName := FileName;
                            SalesHeader.Modify();
                        end;
                    end;
                end;


            EntityTypeVar::Purchase:
                begin
                    if not EBS."Purchase Setup" then
                        Error('Please enable Purchase Setup in Entity Blob Setup');

                    if PurchHeader.get(DocType, DocNo) then begin
                        if PurchHeader."Document Type" = PurchHeader."Document Type"::"Blanket Order" then
                            FileName := 'PBO-' + PurchHeader."No.";
                        if PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" then
                            FileName := 'PCRMemo-' + PurchHeader."No.";
                        if PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice then
                            FileName := 'PInv-' + PurchHeader."No.";
                        if PurchHeader."Document Type" = PurchHeader."Document Type"::Order then
                            FileName := 'PO-' + PurchHeader."No.";
                        if PurchHeader."Document Type" = PurchHeader."Document Type"::Quote then
                            FileName := 'PQ-' + PurchHeader."No.";
                        if PurchHeader."Document Type" = PurchHeader."Document Type"::"Return Order" then
                            FileName := 'PRetOrder-' + PurchHeader."No.";
                        AzureMgt.UploadFile(FileName);
                        if FileName <> '' then begin
                            PurchHeader.BlobFileName := FileName;
                            PurchHeader.Modify();
                        end;
                    end;

                end;
        end;
    end;

    local procedure DownloadBlobContent()
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        Item: Record Item;
        Employee: Record Employee;
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        AzureMgt: Codeunit "Azure Mgt.";
        FileName: Text[250];
    begin
        case EntityTypeVar of
            EntityTypeVar::Customer:
                begin
                    if not EBS."Customer Setup" then
                        Error('Please enable Customer Setup in Entity Blob Setup');
                    Customer.Get(DocNo);
                    FileName := Customer.BlobFileName;
                    //bc365container (container name created in azureaccount)
                    // Azure login --> Storage Account --> Storage account name--> Properties --> Primary Blob Service Endpoint
                    if FileName <> '' then
                        AzureMgt.DownloadFile(FileName, 'https://bc365azureblob.blob.core.windows.net:443/bc365container/');
                end;
            EntityTypeVar::Vendor:
                begin
                    if not EBS."Vendor Setup" then
                        Error('Please enable Vendor Setup in Entity Blob Setup');
                    Vendor.Get(DocNo);
                    FileName := Vendor.BlobFileName;
                    if FileName <> '' then
                        AzureMgt.DownloadFile(FileName, 'https://bc365azureblob.blob.core.windows.net:443/bc365container/');
                end;

            EntityTypeVar::Item:
                begin
                    if not EBS."Item Setup" then
                        Error('Please enable Item Setup in Entity Blob Setup');
                    Item.Get(DocNo);
                    FileName := Item.BlobFileName;
                    if FileName <> '' then
                        AzureMgt.DownloadFile(FileName, 'https://bc365azureblob.blob.core.windows.net:443/bc365container/');
                end;
            EntityTypeVar::Employee:
                begin
                    if not EBS."Employee Setup" then
                        Error('Please enable Employee Setup in Entity Blob Setup');
                    Employee.Get(DocNo);
                    FileName := Employee.BlobFileName;
                    if FileName <> '' then
                        AzureMgt.DownloadFile(FileName, 'https://bc365azureblob.blob.core.windows.net:443/bc365container/');
                end;

            EntityTypeVar::Sales:
                begin
                    if not EBS."Sales Setup" then
                        Error('Please enable Sales Setup in Entity Blob Setup');
                    if SalesHeader.get(DocType, DocNo) then begin
                        FileName := SalesHeader.BlobFileName;
                        if FileName <> '' then
                            AzureMgt.DownloadFile(FileName, 'https://bc365azureblob.blob.core.windows.net:443/bc365container/');
                    end;
                end;


            EntityTypeVar::Purchase:
                begin
                    if not EBS."Purchase Setup" then
                        Error('Please enable Purchase Setup in Entity Blob Setup');

                    if PurchHeader.get(DocType, DocNo) then begin
                        FileName := PurchHeader.BlobFileName;
                        if FileName <> '' then
                            AzureMgt.DownloadFile(FileName, 'https://bc365azureblob.blob.core.windows.net:443/bc365container/');
                    end;
                end;
        end;
    end;

    trigger OnOpenPage()
    begin
        GetEBSSetup();
    end;
}