page 50023 "SEI Released WO Lines"
{
    Caption = 'SEI Released WO Lines';
    PageType = List;
    SourceTable = "Prod. Order Line";
    SourceTableView = where(Status = const(Released));
    //CardPageId = 99000831;
    Editable = false;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Area"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec."Quantity (Base)")
                {
                    ApplicationArea = All;
                }
                field("Finished Quantity"; Rec."Finished Quantity")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Planning Flexibility"; Rec."Planning Flexibility")
                {
                    ApplicationArea = All;
                }
                field("SEI Customer Ref. No."; Rec."SEI Customer Ref. No.")
                {
                    ApplicationArea = All;
                }
                field("SEI Order Promising Cust. Name"; Rec."SEI Order Promising Cust. Name")
                {
                    ApplicationArea = All;

                }
                field("SEI Tmp. Order Prom. SAP No."; Rec."SEI Tmp. Order Prom. SAP No.")
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
                        ProdOrder.Init();
                        if ProdOrder.Get(Rec.Status, Rec."Prod. Order No.") then begin
                            PageManagement.PageRun(ProdOrder);
                        end;
                    end;
                }
            }
        }
    }
    var
        ProdOrder: Record "Production Order";


}
