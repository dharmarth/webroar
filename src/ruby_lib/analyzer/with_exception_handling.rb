# WebROaR - Ruby Application Server - http://webroar.in/
# Copyright (C) 2009  Goonj LLC
#
# This file is part of WebROaR.
#
# WebROaR is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# WebROaR is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with WebROaR.  If not, see <http://www.gnu.org/licenses/>.

module Webroar
  module Analyzer
    module WithExceptionHandling
      MAX_TRIAL = 3
      def with_exception_handling(log_message, &block)
        trial = 0
        begin
          block.call
        rescue ActiveRecord::StatementInvalid, Exception => e
          WLogger.info(log_message)        
          WLogger.error("#{e.message}. try no #{trial+1}")     
          if trial < MAX_TRIAL
            trial += 1            
            sleep(2)          
            retry
          end
          WLogger.info(log_message)  
          WLogger.error(e) 
          WLogger.error(e.backtrace.join("\n"))
        end
      end      
    end
  end
end
