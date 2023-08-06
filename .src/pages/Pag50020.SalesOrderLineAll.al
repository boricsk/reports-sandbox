page 50020 "SEI Sales Order Line All"
{
    Caption = 'SEI Sales Order Line All';
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type" = const(Order));

    Editable = false;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Document No."; Rec."Document No.") { ApplicationArea = All; }
                field("Customer Name"; GetCustomerName(Rec."Document No.")) { ApplicationArea = All; }
                field("SAP SO Num."; GetSapSo(Rec."Document No.")) { ApplicationArea = All; }
                field("SAP PO Num."; GetSapPo(Rec."Document No.")) { ApplicationArea = All; }
                field("SEI SAP Order Unique ID"; Rec."SEI SAP Order Unique ID")
                {
                    ApplicationArea = All;
                }
                field("SEI Changed Order Date"; Rec."SEI Changed Order Date")
                {
                    ApplicationArea = All;
                }
                field("SEI SAP Original Req. Date"; Rec."SEI SAP Original Req. Date")
                {
                    ApplicationArea = All;
                }
                field("Planned Delivery Date"; Rec."Planned Delivery Date")
                {
                    ApplicationArea = All;
                }
                field("Planned Shipment Date"; Rec."Planned Shipment Date")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Item Reference Unit of Measure"; Rec."Item Reference Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Amount (LCY)"; Rec."Outstanding Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Amount"; Rec."Outstanding Amount")
                {
                    ApplicationArea = All;
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ApplicationArea = All;
                }
                field("Quantity Shipped"; Rec."Quantity Shipped")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
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
                        if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                            PageManagement.PageRun(SalesHeader);
                        end;
                    end;
                }
            }
        }
    }
    var
        SalesHeader: Record "Sales Header";

    local procedure GetCustomerName(OrderNum: Code[20]): Text;
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Init();
        SalesHeader.Get(Rec."Document Type"::Order, OrderNum);
        //SalesHeader.SetFilter("No.", OrderNum);
        exit(SalesHeader."Ship-to Name");
    end;

    local procedure GetSapSo(OrderNum: Code[20]): Text;
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Init();
        SalesHeader.Get(Rec."Document Type"::Order, OrderNum);
        exit(SalesHeader."SEI SAP SO No.");
    end;

    local procedure GetSapPo(OrderNum: Code[20]): Text;
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Init();
        SalesHeader.Get(Rec."Document Type"::Order, OrderNum);
        exit(SalesHeader."SEI SAP PO No.");
    end;

}
