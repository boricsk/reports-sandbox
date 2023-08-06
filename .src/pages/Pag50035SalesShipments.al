page 50035 "SEI Sales Shipments"
{
    Caption = 'SEI Sales Shipments';
    PageType = List;
    SourceTable = "Sales Shipment Line";
    SourceTableView = where(Quantity = filter(<> 0));
    //CardPageId = 99000831;
    Editable = false;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.") { }
                field("SAP SO Num."; getSONumber(Rec."Document No.")) { }
                field("SAP PO Num."; getPONumber(Rec."Document No.")) { }
                field("Customer name"; getCustomerName(Rec."Document No.")) { }
                field("Document date"; getDocDate(Rec."Document No.")) { }
                field("No."; Rec."No.") { }
                field(Description; Rec.Description) { }
                field("Location Code"; Rec."Location Code") { }
                field("Posting Group"; Rec."Posting Group") { }
                field("Shipment Date"; Rec."Shipment Date") { }
                field("Unit of Measure"; Rec."Unit of Measure") { }
                field(Quantity; Rec.Quantity) { }
                field("Quantity (Base)"; Rec."Quantity (Base)") { }
                field("Quantity Invoiced"; Rec."Quantity Invoiced") { }
                field("Unit Price"; Rec."Unit Price") { }
                field("Unit Cost"; Rec."Unit Cost") { }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)") { }
                field("VAT %"; Rec."VAT %") { }
                field("VAT Base Amount"; Rec."VAT Base Amount") { }
                field("HUNLOC VAT Date"; Rec."HUNLOC VAT Date") { }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group") { }
                field("Gross Weight"; Rec."Gross Weight") { }
                field("Net Weight"; Rec."Net Weight") { }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code") { }
                field("Qty. Shipped Not Invoiced"; Rec."Qty. Shipped Not Invoiced") { }
                field("Qty. Invoiced (Base)"; Rec."Qty. Invoiced (Base)") { }
                field("Order No."; Rec."Order No.") { }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Cross-Reference No."; Rec."Cross-Reference No.") { }
                field("Shipping Time"; Rec."Shipping Time") { }
                field("Planned Shipment Date"; Rec."Planned Shipment Date") { }
                field("Planned Delivery Date"; Rec."Planned Delivery Date") { }
                field("SEI SAP Original Req. Date"; Rec."SEI SAP Original Req. Date") { }
                field("SEI Confirmed ETA Date"; Rec."SEI Confirmed ETA Date") { }
                field("SEI Changed Order Date"; Rec."SEI Changed Order Date") { }
                field("SEI Proform Invoice Price"; Rec."SEI Proform Invoice Price") { }
                //field("Shipment Date";"Shipment Date")
                field("Shipment method code"; getShipmentMethodCode(Rec."Document No.")) { }
                field("Shipment agent code"; getShippingAgentCode(Rec."Document No.")) { }
                field("Shipment agent service code"; getShippingAgentServiceCode(Rec."Document No.")) { }
                field("Tracking number"; getTrackingNumber(Rec."Document No.")) { }

                field(SystemCreatedAt; Rec.SystemCreatedAt) { }
                field(SystemCreatedBy; getUserName(Rec.SystemCreatedBy)) { }
                field(SystemModifiedAt; Rec.SystemModifiedAt) { }
                field(SystemModifiedBy; getUserName(Rec.SystemModifiedBy)) { }
                field("Delay based on conf. [days]"; calcDelayBasedConfiration(Rec."Planned Shipment Date", Rec."Shipment Date")) { }
                field("Delay based on req. date [days]"; calcDelayBasedOrigRequest(Rec."SEI SAP Original Req. Date", Rec."Shipment Date", Rec."SEI Changed Order Date")) { }
            }


        }

    }


    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Card)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Document';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F2';
                    ToolTip = 'Open the document that the selected line exists on.';

                    trigger OnAction()
                    var
                        PageManagement: Codeunit "Page Management";
                    begin
                        SalesHeader.Init();
                        if SalesHeader.Get(Rec."Document No.") then begin
                            PageManagement.PageRun(SalesHeader);
                        end;
                    end;
                }
                action(OTDReport)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'OTD Report';
                    Image = Delivery;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F3';
                    ToolTip = 'Run on time delivery report';

                    trigger OnAction()
                    var
                        OTDData: Record "Sales Shipment Line";
                    begin
                        //Report.RunModal(Report::"SEI Production Order 0P", true, false, Prod_Order);
                        report.RunModal(Report::"SEI On Time Delivery", true, false, OTDData);
                    end;
                }

            }

        }
    }
    trigger OnAfterGetCurrRecord()
    begin

    end;

    var
        SalesHeader: Record "Sales Shipment Header";
        User: Record User;

    local procedure getUserName(SecID: Guid): Text
    begin
        User.Init();
        if User.Get(SecID) then
            exit(User."User Name")
        else
            exit('')

    end;

    local procedure getSONumber(DocNum: Code[20]): Text
    Begin
        SalesHeader.Init();
        if SalesHeader.Get(DocNum) then
            exit(SalesHeader."SEI SAP SO No.")
        else
            exit('')
    End;

    local procedure getPONumber(DocNum: Code[20]): Text
    Begin
        SalesHeader.Init();
        if SalesHeader.Get(DocNum) then
            exit(SalesHeader."SEI SAP PO No.")
        else
            exit('')
    End;

    local procedure getDocDate(DocNum: Code[20]): Date
    Begin
        SalesHeader.Init();
        if SalesHeader.Get(DocNum) then
            exit(SalesHeader."Document Date")
        else
            exit(0D)
    End;

    local procedure getCustomerName(DocNum: Code[20]): Text
    Begin
        SalesHeader.Init();
        if SalesHeader.Get(DocNum) then
            exit(SalesHeader."Ship-to Name")
        else
            exit('')
    End;

    local procedure getShipmentMethodCode(DocNum: Code[20]): Text
    Begin
        SalesHeader.Init();
        if (SalesHeader.Get(DocNum)) then
            exit(SalesHeader."Shipment Method Code")
        else
            exit('')
    End;

    local procedure getShippingAgentCode(DocNum: Code[20]): Text
    begin
        SalesHeader.Init();
        if SalesHeader.Get(DocNum) then
            exit(SalesHeader."Shipping Agent Code")
        else
            exit('')
    end;

    local procedure getShippingAgentServiceCode(DocNum: Code[20]): Text
    begin
        SalesHeader.Init();
        if (SalesHeader.Get(DocNum)) then
            exit(SalesHeader."Shipping Agent Service Code")
        else
            exit('')
    end;

    local procedure getTrackingNumber(DocNum: Code[20]): Text
    begin
        SalesHeader.Init();
        if (SalesHeader.Get(DocNum)) then
            exit(SalesHeader."Package Tracking No.")
        else
            exit('')
    end;

    local procedure calcDelayBasedConfiration(ConfDate: Date; ShipmentDate: Date): Integer
    begin
        exit(ShipmentDate - ConfDate)
    end;

    local procedure calcDelayBasedOrigRequest(RequestDate: Date; ShipmentDate: Date; ChangedDate: Date): Integer
    begin
        if RequestDate <> 0D then begin
            if ChangedDate <> 0D then
                exit(ShipmentDate - ChangedDate)
            else
                exit(ShipmentDate - RequestDate)
        end;
    end;

}