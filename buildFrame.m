%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function frame = buildFrame(numFrame)

    frame= zeros(8,1);
    

%     frame(1)=bin2dec([dec2bin(numFrame(1),8) dec2bin(numFrame(2),8) dec2bin(numFrame(3),8) dec2bin(numFrame(4),8)]);
%    
%     frame(2)=bin2dec([dec2bin(numFrame(5),8) dec2bin(numFrame(6),8) dec2bin(numFrame(7),8) dec2bin(numFrame(8),8)]);  
%     frame(3)=bin2dec([dec2bin(numFrame(9),8) dec2bin(numFrame(10),8) dec2bin(numFrame(11),8) dec2bin(numFrame(12),8)]);
%     frame(4)=bin2dec([dec2bin(numFrame(13),8) dec2bin(numFrame(14),8) dec2bin(numFrame(15),8) dec2bin(numFrame(16),8)]);
%     frame(5)=bin2dec([dec2bin(numFrame(17),8) dec2bin(numFrame(18),8) dec2bin(numFrame(19),8) dec2bin(numFrame(20),8)]);
%     frame(6)=bin2dec([dec2bin(numFrame(21),8) dec2bin(numFrame(22),8) dec2bin(numFrame(23),8) dec2bin(numFrame(24),8)]);
%     frame(7)=bin2dec([dec2bin(numFrame(25),8) dec2bin(numFrame(26),8) dec2bin(numFrame(27),8) dec2bin(numFrame(28),8)]);
%    frame(8)=bin2dec([dec2bin(numFrame(29),8) dec2bin(numFrame(30),8) dec2bin(numFrame(31),8) dec2bin(numFrame(32),8)]);    


    frame(1)=bin2dec([dec2bin(numFrame(1),8) dec2bin(numFrame(2),8)]);   
    frame(2)=bin2dec([dec2bin(numFrame(3),8) dec2bin(numFrame(4),8) ]);  
    frame(3)=bin2dec([dec2bin(numFrame(5),8) dec2bin(numFrame(6),8) ]);
    frame(4)=bin2dec([dec2bin(numFrame(7),8) dec2bin(numFrame(8),8) ]);
    frame(5)=bin2dec([dec2bin(numFrame(9),8) dec2bin(numFrame(10),8) ]);
    frame(6)=bin2dec([dec2bin(numFrame(11),8) dec2bin(numFrame(12),8) ]);
    frame(7)=bin2dec([dec2bin(numFrame(13),8) dec2bin(numFrame(14),8) ]);
    frame(8)=bin2dec([dec2bin(numFrame(15),8) dec2bin(numFrame(16),8) ]);    
    
    
    
%     if(frame(7)<100)
%         display([int2str(frame(7)),' ',dec2bin(numFrame(25),4),' ',dec2bin(numFrame(26),8),' ',dec2bin(numFrame(27),8),' '...
%             ,dec2bin(numFrame(28),4)])
%         
%         display([int2str(frame(7)),' ',int2str(numFrame(25)),' ',int2str(numFrame(26)),' ',int2str(numFrame(27)),' '...
%             ,int2str(numFrame(28))])        
%         
%     end


    
    for j=1:6
            %if(numFrame(32+j)==1)
            if(numFrame(16+j)==1)
                frame(j)=frame(j)*-1;
            end
    end

end