report 50030 "SEI Open orders"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.src/report/rdlc/Rep50030.OpenOrders.rdlc';
    ApplicationArea = All;
    Caption = 'SEI Open orders', Locked = true; //nem kerül be a ford. fileba.
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            RequestFilterFields = "Location Code", "SEI SAP PO No.", "SEI SAP SO No.", "No.";

            column(SalesHeaderOrdenNo_; "No.") { }
            column(SalesHeaderBill_to_Name; "Ship-to Name") { }
            column(SalesHeaderPosting_Date; "Posting Date") { }
            column(SalesHeaderExternal_Document_No_; "External Document No.") { }
            column(SalesHeaderStatus; Status) { }
            column(SalesHeaderSEI_SAP_PO_No_; "SEI SAP PO No.") { }
            column(SalesHeaderSEI_SAP_SO_No_; "SEI SAP SO No.") { }
            column(SalesHeaderLocation_Code; "Location Code") { }
            column(SalesHeaderSEI_Customer_Ref__No_; "SEI Customer Ref. No.") { }

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                ///RequestFilterFields = "BOM Item No.";
                column(Document_No_; "Document No.") { }
                column(No_; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Outstanding_Quantity; "Outstanding Quantity") { }
                column(Planned_Shipment_Date; "Planned Shipment Date") { }
                column(Planned_Delivery_Date; "Planned Delivery Date") { }
                column(SEI_Confirmed_ETA_Date; "SEI Confirmed ETA Date") { }
                column(GetMethod; GetMethod("SEI Confirmed ETA Date")) { }
                column(SEI_Changed_Order_Date; "SEI Changed Order Date") { }


                trigger OnPreDataItem()
                begin
                    "Sales Line".SetFilter("No.", RequestPageItemNumber);
                    //setrange-ben a joker karakterek nem működnek.
                end;

            }

            trigger OnPreDataItem()
            begin
                "Sales Header".SetRange("Document Type", "Document Type"::Order);
                "Sales Header".SetRange(Status, Status::Open);
            end;

        }

    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group("Finished Item Number")
                {
                    field(RequestPageItemNumber; RequestPageItemNumber)
                    {
                        ApplicationArea = All;
                        Caption = 'Item number';


                    }


                }
            }
        }

    }

    labels
    {
        LblTitle = 'SEI Open order list', Locked = true;
        LblReguestedDate = 'Requested date';
        LblConfimDate = 'Confirmed date';
        LblSAPSO = 'SAP SO number';
        LblSAPPO = 'SAP PO number';
        LblItem = 'Item';
        LblOrderNumberNAV = 'Order number';
        LblQty = 'Quantity';
        LblOpenQty = 'Open quantity';
        LblPostingDate = 'Posting date';
        LblPage = 'Page :';
    }


    var
        RequestPageItemNumber: Code[20];


    trigger OnInitReport()
    begin
        //"Sales Header".Status
    end;

    local procedure GetMethod(ConfirmationDate: Date): Text
    begin
        if ConfirmationDate = 0D then
            exit('New Order')
        else
            exit('Date changed')
    end;


}