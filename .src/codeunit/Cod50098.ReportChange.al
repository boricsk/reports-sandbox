//eredeti report cseréje egy másikra
codeunit 50098 SEIReportSubtitution
{
    // ha van report rá, de jelentés kiválasztással nem lehet, itt tudod lecserélni
    //                                               ebben a kodunitban ezt az esemény váltom ki az itt definiált proc.-al
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', true, false)]
    local procedure OnSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin
        case ReportId of
            Report::"Phys. Inventory List": // a report neve, amit cserélnél
                begin
                    NewReportId := Report::"SEI Physical Inventory List"; // a saját reportod neve, amire cseréled
                end;
            // Report::"Issue Reminders":
            //     begin
            //         NewReportId := Report::"SEI Issue Reminders";
            //     end;
            // Report::"Fixed Asset - Book Value 01":
            //     begin
            //         NewReportId := Report::"SEI Fixed Asset - Book Value 01";
            //     end;
            Report::"Inventory Movement":
                begin
                    NewReportId := Report::"SEI Inventory Movement";
                end;
            else
        end
    end;

    // az események a base application kódjaiban találhatóak meg ezekre lehet feliratkozni.
    [EventSubscriber(ObjectType::Page, Page::"Item Card", 'OnAfterOnOpenPage', '', true, false)]
    local procedure ShowWelcome()
    var
        user: Text;
    begin
        user := UserId;
        if user = 'TOTH.STEFANIA' then begin
            Message('🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄🦄');
        end;
    end;

}