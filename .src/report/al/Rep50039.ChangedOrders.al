report 50039 "SEI Changed orders"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.src/report/rdlc/Rep50039.ChangedOrders.rdlc';
    ApplicationArea = All;
    Caption = 'SEI Changed Orders', Locked = true; //nem kerül be a ford. fileba.
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            column(Document_No_; "Document No.") { }
            column(No_; "No.") { }
            column(Description; Description) { }
            column(Quantity; Quantity) { }
            column(Outstanding_Quantity; "Outstanding Quantity") { }
            column(Planned_Shipment_Date; "Planned Shipment Date") { }
            column(Planned_Delivery_Date; "Planned Delivery Date") { }
            column(SEI_Confirmed_ETA_Date; "SEI Confirmed ETA Date") { }
            column(SEI_SAP_Original_Req__Date; "SEI SAP Original Req. Date") { }
            column(SEI_Changed_Order_Date; "SEI Changed Order Date") { }
            column(isChanged; isChanged("Planned Delivery Date", "SEI Changed Order Date")) { }


            trigger OnPreDataItem()
            begin
                "Sales Line".SetRange("Document Type", "Document Type"::Order);
                "Sales Line".SetFilter("Outstanding Quantity", '<>0');
                "Sales Line".SetFilter("Shortcut Dimension 1 Code", location);

                //setrange-ben a joker karakterek nem működnek.
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
                group("Area")
                {
                    field(location; location)
                    {
                        ApplicationArea = All;
                        Caption = 'Select location';
                        TableRelation = "Dimension Value".Code where("Dimension Code" = const('DIVISION'));
                    }
                }
            }
        }

    }

    labels
    {
        LblTitle = 'SEI Changed order list', Locked = true;
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
        location: Text;

    trigger OnInitReport()
    begin
        //"Sales Header".Status
    end;

    local procedure isChanged(deliveryDate: Date; changedDate: Date): Boolean
    begin
        if changedDate <> 0D then begin
            if changedDate = deliveryDate then begin
                exit(false)
            end else begin
                exit(true);
            end;
        end else begin
            exit(false);
        end;
    end;

}