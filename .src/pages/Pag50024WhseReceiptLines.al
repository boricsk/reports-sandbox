page 50024 "SEI Whse. Receipt Lines"
{
    Caption = 'SEI Whse. Receipt Lines';
    PageType = List;
    SourceTable = "Warehouse Receipt Line";
    SourceTableView = SORTING("No.") order(descending);
    //CardPageId = 99000831;
    Editable = false;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {

            repeater(General)
            {
                field("No."; Rec."No.") { ApplicationArea = All; Caption = 'Receipt Number'; }
                //field("Line No."; Rec."Line No.") { ApplicationArea = All; Caption = 'Line number'; }
                field("Purchase Order"; Rec."Source No.") { ApplicationArea = All; Caption = 'PO Number'; }
                field("Supplier"; Rec."Shelf No.") { ApplicationArea = All; Caption = 'Supplier'; }
                field("Item No."; Rec."Item No.") { ApplicationArea = All; Caption = 'Item'; }
                field(Description; Rec.Description) { ApplicationArea = All; Caption = 'Description'; }
                field("Description 2"; Rec."Description 2") { ApplicationArea = All; Caption = 'Description 2'; }
                field(LongDescription; GetLongDesc(Rec."Item No.")) { ApplicationArea = All; Caption = 'Long Description'; }
                field("Qty. to Receive"; Rec."Qty. to Receive") { ApplicationArea = All; Caption = 'Receive qty.'; }
                field("Estimated Arrival Date"; GetArrivalDate(Rec."No.")) { ApplicationArea = All; Caption = 'Estimated Arrival Date'; }
                field("Shipment Document Number"; GetShipmentNo(Rec."No.")) { ApplicationArea = All; Caption = 'Shipment Doc. Number'; }
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
                        WhseHead.Init();
                        if WhseHead.Get(Rec."No.") then begin
                            PageManagement.PageRun(WhseHead);
                        end;
                    end;
                }
            }
        }
    }
    var
        WhseLines: Record "Warehouse Receipt Line";
        WhseHead: Record "Warehouse Receipt Header";
        Items: Record Item;

    local procedure GetArrivalDate(Number: Code[20]): Date
    begin
        WhseHead.Init();
        if WhseHead.Get(Number) then begin
            exit(WhseHead."Posting Date");
        end;
    end;

    local procedure GetShipmentNo(Number: Code[20]): Text
    begin
        WhseHead.Init();
        if WhseHead.Get(Number) then begin
            exit(WhseHead."Vendor Shipment No.");
        end;
    end;

    local procedure GetLongDesc(ItemNum: Code[20]): Text
    begin
        Items.Init();
        if Items.Get(ItemNum) then begin
            exit(items."SEI Long Description");
        end;
    end;
}
