codeunit 50200 "Azure Mgt."
{

/// Referred to Blog --> https://deepanshsaini.blogspot.com/2019/04/uploading-and-downloading-file-to-azure.html

    trigger OnRun()
    begin

    end;

    procedure UploadFile(Var _FileName : Text[250])
    var
        tempblob: Record TempBlob;
        fileMgt: Codeunit "File Management";
        selectedFile: Text;
        SelectedFileName: Text;
        fileextn: Text[10];
        httpClient: HttpClient;
        httpContent: HttpContent;
        jsonBody: text;
        httpResponse: HttpResponseMessage;
        httpHeader: HttpHeaders;
    begin
        selectedFile := fileMgt.OpenFileDialog('NAV File Browser', '', '');
        if selectedFile = '' then begin
           CLEAR(_FileName);
           exit;
        end;    

        tempblob.Blob.Import(selectedFile);

        SelectedFileName := _FileName + '-' + Copystr(fileMgt.GetFileName(selectedFile), 1, StrPos(fileMgt.GetFileName(selectedFile), '.') - 1);
        
        // jsonBody := ' {"base64":"' + GetMimeType(selectedFile) + ';base64,' + tempblob.ToBase64String() +
        // '","fileName":"' + delchr(fileMgt.GetFileName(selectedFile), '=', '.' + fileMgt.GetExtension(selectedFile)) +
        // '","fileType":"' + fileMgt.GetExtension(selectedFile) + '"}';

        jsonBody := ' {"base64":"' + GetMimeType(selectedFile) + ';base64,' + tempblob.ToBase64String() +
        '","fileName":"' + SelectedFileName +
        '","fileType":"' + fileMgt.GetExtension(selectedFile) + '"}';

        if GetMimeType(selectedFile) = 'data:text/plain' then
            fileextn := 'plain'
        else
            fileextn := copystr(fileMgt.GetExtension(selectedFile), 1, 10);

        _FileName := CopyStr(SelectedFileName,1,230) + '.' + fileextn; 

        httpContent.WriteFrom(jsonBody);
        httpContent.GetHeaders(httpHeader);
        httpHeader.Remove('Content-Type');
        httpHeader.Add('Content-Type', 'application/json');
        httpClient.Post('https://bc365azureapp.azurewebsites.net/api/UploadFile?code=wRjXNCEx9k1OcA1EjJ/YI0iMubNddu5aWsPVzAKIO3hxWHC9GDIaHw==', httpContent, httpResponse);
    end;

    procedure DownloadFile(fileName: Text; blobUrl: Text)
    var
        tempblob: Record TempBlob;
        NVInStream: InStream;
        httpClient: HttpClient;
        httpContent: HttpContent;
        jsonBody: text;
        httpResponse: HttpResponseMessage;
        httpHeader: HttpHeaders;
        base64: Text;
    begin
        jsonBody := ' {"url":"' + blobUrl + '","fileName":"' + fileName + '"}';
        httpContent.WriteFrom(jsonBody);
        httpContent.GetHeaders(httpHeader);
        httpHeader.Remove('Content-Type');
        httpHeader.Add('Content-Type', 'application/json');
        httpClient.Post('https://bc365azureapp.azurewebsites.net/api/DownloadFile?code=HcMeDd5YCfHOLmCazTQteRbA9NJCg9QLAzMy8Z7R3rDTGnlV/Oltbg==', httpContent, httpResponse);
        httpResponse.Content().ReadAs(base64);
        base64 := DelChr(base64, '=', '"');
        tempblob.FromBase64String(base64);

        clear(NVInStream);
        tempblob.Blob.CreateInStream(NVInStream);
        DOWNLOADFROMSTREAM(NVInStream, '', '', 'Text Documents (*.TXT)|*.TXT|All files (*.*)|*.*', fileName);

    end;

    local procedure GetMimeType(selectedFile: Text): Text
    var
        fileMgt: Codeunit "File Management";
        mimeType: Text;
    begin
        case lowercase(fileMgt.GetExtension(selectedFile)) of
            'pdf':
                mimeType := 'data:application/pdf';
            'txt':
                mimeType := 'data:text/plain';
            'png':
                mimeType := 'data:image/png';
            else
                Error('File Format Not Supported');
        end;
        EXIT(mimeType);
    end;
}