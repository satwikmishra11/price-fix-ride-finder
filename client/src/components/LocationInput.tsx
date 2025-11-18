
import React, { useState } from 'react';
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

interface LocationInputProps {
  onSearch: (pickup: string, dropoff: string) => void;
}

const LocationInput = ({ onSearch }: LocationInputProps) => {
  const [pickup, setPickup] = useState("");
  const [dropoff, setDropoff] = useState("");
  const [isSearching, setIsSearching] = useState(false);

  const handleSearch = () => {
    if (pickup && dropoff) {
      setIsSearching(true);
      // Simulate API call delay
      setTimeout(() => {
        onSearch(pickup, dropoff);
        setIsSearching(false);
      }, 1500);
    }
  };

  return (
    <div className="w-full max-w-md mx-auto mt-6">
      <div className="bg-white rounded-xl p-4 shadow-md">
        <div className="space-y-4">
          <div className="relative">
            <div className="absolute left-3 top-3">
              <div className="w-4 h-4 rounded-full bg-brand-purple"></div>
            </div>
            <Input
              placeholder="Enter pickup location"
              className="pl-10 py-6 bg-secondary"
              value={pickup}
              onChange={(e) => setPickup(e.target.value)}
            />
          </div>
          
          <div className="relative">
            <div className="absolute left-3 top-3">
              <div className="w-4 h-4 rounded-full border-2 border-brand-purple"></div>
            </div>
            <Input
              placeholder="Enter drop-off location"
              className="pl-10 py-6 bg-secondary"
              value={dropoff}
              onChange={(e) => setDropoff(e.target.value)}
            />
          </div>
          
          <Button 
            className="w-full py-6 text-base"
            disabled={!pickup || !dropoff || isSearching}
            onClick={handleSearch}
          >
            {isSearching ? (
              <span className="flex items-center gap-2">
                <svg 
                  className="animate-spin" 
                  width="20" 
                  height="20" 
                  viewBox="0 0 24 24" 
                  fill="none" 
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <circle 
                    cx="12" 
                    cy="12" 
                    r="10" 
                    stroke="currentColor" 
                    strokeWidth="4" 
                    strokeOpacity="0.25"
                  />
                  <path 
                    d="M12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22" 
                    stroke="currentColor" 
                    strokeWidth="4" 
                    strokeLinecap="round"
                  />
                </svg>
                Finding rides...
              </span>
            ) : (
              "Find Rides"
            )}
          </Button>
        </div>
      </div>
    </div>
  );
};

export default LocationInput;
