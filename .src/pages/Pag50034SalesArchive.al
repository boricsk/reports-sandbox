page 50034 "SEI Sales Archive"
{
    Caption = 'SEI Sales Archive';
    PageType = List;
    SourceTable = "Sales Line Archive";
    //SourceTableView = where(Status = const(Released));
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
                field("Document No."; Rec."Document No.") { ApplicationArea = All; }
                field("Version No."; Rec."Version No.") { ApplicationArea = All; }
                field("SAP SO Number"; getSONumber(Rec."Document Type", Rec."Document No.", Rec."Doc. No. Occurrence", Rec."Version No.")) { ApplicationArea = All; }
                field("SAP PO Number"; getPONumber(Rec."Document Type", Rec."Document No.", Rec."Doc. No. Occurrence", Rec."Version No.")) { ApplicationArea = All; }
                field("Document date"; getDocDate(Rec."Document Type", Rec."Document No.", Rec."Doc. No. Occurrence", Rec."Version No.")) { ApplicationArea = All; }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.") { ApplicationArea = All; }
                field("Customer name"; getCustomerName(Rec."Document Type", Rec."Document No.", Rec."Doc. No. Occurrence", Rec."Version No.")) { ApplicationArea = All; }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.") { ApplicationArea = All; }
                field("Completely Shipped"; Rec."Completely Shipped") { ApplicationArea = All; }
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Cross-Reference No."; Rec."Cross-Reference No.") { ApplicationArea = All; }
                field("Item Reference No."; Rec."Item Reference No.") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Description 2"; Rec."Description 2") { ApplicationArea = All; }
                field("Location Code"; Rec."Location Code") { ApplicationArea = All; }
                field("Shipment Date"; Rec."Shipment Date") { ApplicationArea = All; }
                field("Unit of Measure"; Rec."Unit of Measure") { ApplicationArea = All; }
                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
                field("Outstanding Quantity"; Rec."Outstanding Quantity") { ApplicationArea = All; }
                field("Unit Price"; Rec."Unit Price") { ApplicationArea = All; }
                field("Unit Cost"; Rec."Unit Cost") { ApplicationArea = All; }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)") { ApplicationArea = All; }
                field("VAT %"; Rec."VAT %") { ApplicationArea = All; }
                field("VAT Base Amount"; Rec."VAT Base Amount") { ApplicationArea = All; }
                field("Line Amount"; Rec."Line Amount") { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field("Amount Including VAT"; Rec."Amount Including VAT") { ApplicationArea = All; }
                field("Outstanding Amount"; Rec."Outstanding Amount") { ApplicationArea = All; }
                field("Outstanding Amount (LCY)"; Rec."Outstanding Amount (LCY)") { ApplicationArea = All; }
                field("Gross Weight"; Rec."Gross Weight") { ApplicationArea = All; }
                field("Net Weight"; Rec."Net Weight") { ApplicationArea = All; }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code") { ApplicationArea = All; }
                field("Quantity Shipped"; Rec."Quantity Shipped") { ApplicationArea = All; }
                field("Quantity Invoiced"; Rec."Quantity Invoiced") { ApplicationArea = All; }
                field("Shipped Not Invoiced"; Rec."Shipped Not Invoiced") { ApplicationArea = All; }
                field("Shipped Not Invoiced (LCY)"; Rec."Shipped Not Invoiced (LCY)") { ApplicationArea = All; }
                field("Shipping Agent Code"; getShippingAgentCode(Rec."Document Type", Rec."Document No.", Rec."Doc. No. Occurrence", Rec."Version No.", Rec."Completely Shipped")) { ApplicationArea = All; }
                field("Shipping Agent Service Code"; getShippingAgentServiceCode(Rec."Document Type", Rec."Document No.", Rec."Doc. No. Occurrence", Rec."Version No.", Rec."Completely Shipped")) { ApplicationArea = All; }
                field("Shipment method"; getShipmentMethodCode(Rec."Document Type", Rec."Document No.", Rec."Doc. No. Occurrence", Rec."Version No.", Rec."Completely Shipped")) { ApplicationArea = All; }
                //field("Shipment tracking"; getTrackingNumber(Rec."Document Type", Rec."Document No.", Rec."Doc. No. Occurrence", Rec."Version No.", Rec."Completely Shipped")) { ApplicationArea = All; }
                field("Planned Delivery Date"; Rec."Planned Delivery Date") { ApplicationArea = All; }
                field("Planned Shipment Date"; Rec."Planned Shipment Date") { ApplicationArea = All; }
                field(SystemCreatedAt; Rec.SystemCreatedAt) { ApplicationArea = All; }
                field(SystemCreatedBy; getUserName(Rec.SystemCreatedBy)) { ApplicationArea = All; }
                field(SystemModifiedAt; Rec.SystemModifiedAt) { ApplicationArea = All; }
                field(SystemModifiedBy; getUserName(Rec.SystemModifiedBy)) { ApplicationArea = All; }



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
                        if SalesHeader.Get(Rec."Document Type", Rec."Document No.", Rec."Doc. No. Occurrence", Rec."Version No.") then begin
                            PageManagement.PageRun(SalesHeader);
                        end;
                    end;
                }

            }

        }
    }
    trigger OnAfterGetCurrRecord()
    begin

    end;

    var
        SalesHeader: Record "Sales Header Archive";
        User: Record User;

    local procedure getUserName(SecID: Guid): Text
    begin
        User.Init();
        if User.Get(SecID) then
            exit(User."User Name")
        else
            exit('')

    end;

    local procedure getSONumber(DocType: Enum "Sales Document Type"; No: Code[20]; Occurrence: Integer; VersionNo: Integer): Text
    Begin
        SalesHeader.Init();
        if SalesHeader.Get(DocType, No, Occurrence, VersionNo) then
            exit(SalesHeader."SEI SAP SO No.")
        else
            exit('')
    End;

    local procedure getPONumber(DocType: Enum "Sales Document Type"; No: Code[20]; Occurrence: Integer; VersionNo: Integer): Text
    Begin
        SalesHeader.Init();
        if SalesHeader.Get(DocType, No, Occurrence, VersionNo) then
            exit(SalesHeader."SEI SAP PO No.")
        else
            exit('')
    End;

    local procedure getDocDate(DocType: Enum "Sales Document Type"; No: Code[20]; Occurrence: Integer; VersionNo: Integer): Date
    Begin
        SalesHeader.Init();
        if SalesHeader.Get(DocType, No, Occurrence, VersionNo) then
            exit(SalesHeader."Document Date")
        else
            exit(0D)
    End;

    local procedure getCustomerName(DocType: Enum "Sales Document Type"; No: Code[20]; Occurrence: Integer; VersionNo: Integer): Text
    Begin
        //SalesHeader.Reset();
        SalesHeader.Init();
        if SalesHeader.Get(DocType, No, Occurrence, VersionNo) then
            exit(SalesHeader."Ship-to Name")
        else
            exit('')
    End;

    local procedure getShipmentMethodCode(DocType: Enum "Sales Document Type"; No: Code[20]; Occurrence: Integer; VersionNo: Integer; ShipComplete: Boolean): Text
    Begin
        //SalesHeader.Reset();
        SalesHeader.Init();
        if (SalesHeader.Get(DocType, No, Occurrence, VersionNo)) and (ShipComplete) then
            exit(SalesHeader."Shipment Method Code")
        else
            exit('')
    End;

    local procedure getShippingAgentCode(DocType: Enum "Sales Document Type"; No: Code[20]; Occurrence: Integer; VersionNo: Integer; ShipComplete: Boolean): Text
    begin
        SalesHeader.Init();
        if (SalesHeader.Get(DocType, No, Occurrence, VersionNo)) and (ShipComplete) then
            exit(SalesHeader."Shipping Agent Code")
        else
            exit('')
    end;

    local procedure getShippingAgentServiceCode(DocType: Enum "Sales Document Type"; No: Code[20]; Occurrence: Integer; VersionNo: Integer; ShipComplete: Boolean): Text
    begin
        SalesHeader.Init();
        if (SalesHeader.Get(DocType, No, Occurrence, VersionNo)) and (ShipComplete) then
            exit(SalesHeader."Shipping Agent Service Code")
        else
            exit('')
    end;

    local procedure getTrackingNumber(DocType: Enum "Sales Document Type"; No: Code[20]; Occurrence: Integer; VersionNo: Integer; ShipComplete: Boolean): Text
    begin
        SalesHeader.Init();
        if (SalesHeader.Get(DocType, No, Occurrence, VersionNo)) and (ShipComplete) then
            exit(SalesHeader."Package Tracking No.")
        else
            exit('')
    end;
}