report 50051 "SEI Posted Whse Receipt"
{
    DefaultLayout = RDLC;
    //RDLCLayout = './WhsePostedReceipt.rdlc';
    RDLCLayout = '.src/report/rdlc/rep50051.PostedWhseReceipt.rdlc';
    ApplicationArea = Warehouse;
    Caption = 'SEI Warehouse Posted Receipt';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Posted Whse. Receipt Header"; "Posted Whse. Receipt Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(CompanyName; COMPANYPROPERTY.DisplayName)
                {
                }
                column(TodayFormatted; Format(Today, 0, 4))
                {
                }
                column(Assgnd_PostedWhseRcpHeader; "Posted Whse. Receipt Header"."Assigned User ID")
                {
                    IncludeCaption = true;
                }
                column(LocCode_PostedWhseRcpHeader; "Posted Whse. Receipt Header"."Location Code")
                {
                    IncludeCaption = true;
                }
                column(No_PostedWhseRcpHeader; "Posted Whse. Receipt Header"."No.")
                {
                    IncludeCaption = true;
                }
                column(BinMandatoryShow1; not Location."Bin Mandatory")
                {
                }
                column(BinMandatoryShow2; Location."Bin Mandatory")
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(WarehousePostedReceiptCaption; WarehousePostedReceiptCaptionLbl)
                {
                }
                column(PostingDate; "Posted Whse. Receipt Header"."Posting Date")
                {
                    IncludeCaption = true;
                }
                column(Vendor_Shipment_No_; "Posted Whse. Receipt Header"."Vendor Shipment No.") { IncludeCaption = true; }
                dataitem("Posted Whse. Receipt Line"; "Posted Whse. Receipt Line")
                {
                    DataItemLink = "No." = FIELD("No.");
                    DataItemLinkReference = "Posted Whse. Receipt Header";
                    DataItemTableView = SORTING("No.", "Line No.");
                    column(ShelfNo_PostedWhseRcpLine; "Shelf No.")
                    {
                        IncludeCaption = true;
                    }
                    column(ItemNo_PostedWhseRcpLine; "Item No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Desc_PostedWhseRcptLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(UOM_PostedWhseRcpLine; "Unit of Measure Code")
                    {
                        IncludeCaption = true;
                    }
                    column(LocCode_PostedWhseRcpLine; "Location Code")
                    {
                        IncludeCaption = true;
                    }
                    column(Qty_PostedWhseRcpLine; Quantity)
                    {
                        IncludeCaption = true;
                    }
                    column(SourceNo_PostedWhseRcpLine; "Source No.")
                    {
                        IncludeCaption = true;
                    }
                    column(SourceDoc_PostedWhseRcpLine; "Source Document")
                    {
                        IncludeCaption = true;
                    }
                    column(ZoneCode_PostedWhseRcpLine; "Zone Code")
                    {
                        IncludeCaption = true;
                    }
                    column(BinCode_PostedWhseRcpLine; "Bin Code")
                    {
                        IncludeCaption = true;
                    }

                    column(Posted_Source_No_; "Posted Source No.")
                    {
                        IncludeCaption = true;
                    }

                    //Vendor code add begin  
                    dataitem("Purchase Header"; "Purchase Header")
                    {
                        DataItemLink = "No." = FIELD("Source No.");

                        column(No_; "No.") { }
                        column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { IncludeCaption = true; }
                    }
                    //Vendor Code add end
                    trigger OnAfterGetRecord()
                    begin
                        GetLocation("Location Code");
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                GetLocation("Location Code");
            end;
        }
    }

    requestpage
    {
        Caption = 'Warehouse Posted Receipt';

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Location: Record Location;
        CurrReportPageNoCaptionLbl: Label 'Page';
        WarehousePostedReceiptCaptionLbl: Label 'Warehouse - Posted Receipt';

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.Init

        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;
}

