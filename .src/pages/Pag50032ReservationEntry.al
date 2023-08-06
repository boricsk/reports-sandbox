page 50032 "SEI Reservation Entry"
{
    Caption = 'SEI Reservation entry';
    PageType = List;
    SourceTable = "Reservation Entry";
    //SourceTableView = where(Status = const(Released));
    //CardPageId = 99000831;
    Editable = true;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("Entry No."; rec."Entry No.") { ApplicationArea = All; }
                field("Item No."; rec."Item No.") { ApplicationArea = All; }
                field("Location Code"; rec."Location Code") { ApplicationArea = All; }
                field("Quantity (Base)"; rec."Quantity (Base)") { ApplicationArea = All; }
                field("Reservation Status"; rec."Reservation Status") { ApplicationArea = All; }
                field(Description; rec.Description) { ApplicationArea = All; }
                field("Creation Date"; rec."Creation Date") { ApplicationArea = All; }
                field("Transferred from Entry No."; rec."Transferred from Entry No.") { ApplicationArea = All; }
                field("Source Type"; rec."Source Type") { ApplicationArea = All; }
                field("Source Subtype"; rec."Source Subtype") { ApplicationArea = All; }
                field("Source ID"; rec."Source ID") { ApplicationArea = All; }
                field("Source Batch Name"; rec."Source Batch Name") { ApplicationArea = All; }
                field("Source Prod. Order Line"; rec."Source Prod. Order Line") { ApplicationArea = All; }
                field("Source Ref. No."; rec."Source Ref. No.") { ApplicationArea = All; }
                field("Item Ledger Entry No."; rec."Item Ledger Entry No.") { ApplicationArea = All; }
                field("Expected Receipt Date"; rec."Expected Receipt Date") { ApplicationArea = All; }
                field("Shipment Date"; rec."Shipment Date") { ApplicationArea = All; }
                field("Serial No."; rec."Serial No.") { ApplicationArea = All; }
                field("Created By"; rec."Created By") { ApplicationArea = All; }
                field("Changed By"; rec."Changed By") { ApplicationArea = All; }
                field(Positive; rec.Positive) { ApplicationArea = All; }
                field("Qty. per Unit of Measure"; rec."Qty. per Unit of Measure") { ApplicationArea = All; }
                field(Quantity; rec.Quantity) { ApplicationArea = All; }
                field("Action Message Adjustment"; rec."Action Message Adjustment") { }
                field(Binding; rec.Binding) { ApplicationArea = All; }
                field("Suppressed Action Msg."; rec."Suppressed Action Msg.") { ApplicationArea = All; }
                field("Planning Flexibility"; rec."Planning Flexibility") { ApplicationArea = All; }
                field("Appl.-from Item Entry"; rec."Appl.-from Item Entry") { ApplicationArea = All; }
                field("Warranty Date"; rec."Warranty Date") { ApplicationArea = All; }
                field("Expiration Date"; rec."Expiration Date") { ApplicationArea = All; }
                field("Qty. to Handle (Base)"; rec."Qty. to Handle (Base)") { ApplicationArea = All; }
                field("Qty. to Invoice (Base)"; rec."Qty. to Invoice (Base)") { ApplicationArea = All; }
                field("Quantity Invoiced (Base)"; rec."Quantity Invoiced (Base)") { ApplicationArea = All; }
                field("New Serial No."; rec."New Serial No.") { ApplicationArea = All; }
                field("New Lot No."; rec."New Lot No.") { ApplicationArea = All; }
                field("Disallow Cancellation"; rec."Disallow Cancellation") { ApplicationArea = All; }
                field("Lot No."; rec."Lot No.") { ApplicationArea = All; }
                field("Variant Code"; rec."Variant Code") { ApplicationArea = All; }
                field("Appl.-to Item Entry"; rec."Appl.-to Item Entry") { ApplicationArea = All; }
                field(Correction; rec.Correction) { ApplicationArea = All; }
                field("New Expiration Date"; rec."New Expiration Date") { ApplicationArea = All; }
                field("Item Tracking"; rec."Item Tracking") { ApplicationArea = All; }
                field("Untracked Surplus"; rec."Untracked Surplus") { ApplicationArea = All; }
                field("Package No."; rec."Package No.") { ApplicationArea = All; }
                field("New Package No."; rec."New Package No.") { ApplicationArea = All; }
                field(SystemId; rec.SystemId) { ApplicationArea = All; }
                field(SystemCreatedAt; rec.SystemCreatedAt) { ApplicationArea = All; }
                field(SystemCreatedBy; rec.SystemCreatedBy) { ApplicationArea = All; }
                field(SystemModifiedAt; rec.SystemModifiedAt) { ApplicationArea = All; }
                field(SystemModifiedBy; rec.SystemModifiedBy) { ApplicationArea = All; }
                field("SEI Vendor Lot No."; rec."SEI Vendor Lot No.") { ApplicationArea = All; }
            }
        }

    }
    actions
    {
        area(navigation)
        {


        }
    }
    var


}