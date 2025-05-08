
import React from 'react';
import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";

interface RideCardProps {
  provider: "uber" | "ola" | "rapido";
  price: number;
  estimatedTime: number;
  isLowest: boolean;
  onSelect: () => void;
}

const RideCard = ({ provider, price, estimatedTime, isLowest, onSelect }: RideCardProps) => {
  const providerInfo = {
    uber: {
      name: "Uber",
      bgColor: "bg-uber text-white",
      logo: (
        <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
          <path d="M12 2C6.48 2 2 6.48 2 12C2 17.52 6.48 22 12 22C17.52 22 22 17.52 22 12C22 6.48 17.52 2 12 2ZM9.92 16.24H7.76V11.92H9.92V16.24ZM12.06 16.24H9.92V7.76H12.06V16.24ZM16.24 16.24H14.08V11.92H16.24V16.24Z" />
        </svg>
      )
    },
    ola: {
      name: "Ola",
      bgColor: "bg-ola text-white",
      logo: (
        <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
          <path d="M12 2C6.48 2 2 6.48 2 12C2 17.52 6.48 22 12 22C17.52 22 22 17.52 22 12C22 6.48 17.52 2 12 2ZM12 19C8.14 19 5 15.86 5 12C5 8.14 8.14 5 12 5C15.86 5 19 8.14 19 12C19 15.86 15.86 19 12 19Z" />
        </svg>
      )
    },
    rapido: {
      name: "Rapido",
      bgColor: "bg-rapido text-black",
      logo: (
        <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
          <path d="M5 5H15V9H9V15H5V5Z" />
          <path d="M19 9H15V19H5V15H9V19H15V15H19V9Z" />
        </svg>
      )
    }
  };

  return (
    <div 
      className={cn(
        "bg-white rounded-xl p-4 price-card-shadow relative overflow-hidden transition-all duration-300",
        isLowest ? "border-2 border-brand-purple" : "border border-gray-100"
      )}
    >
      {isLowest && (
        <div className="absolute top-0 right-0 bg-brand-purple text-white px-3 py-1 text-xs rounded-bl-lg">
          Best Price
        </div>
      )}
      
      <div className="flex items-center gap-3">
        <div className={cn("w-10 h-10 rounded-full flex items-center justify-center", providerInfo[provider].bgColor)}>
          {providerInfo[provider].logo}
        </div>
        <div>
          <h3 className="font-medium">{providerInfo[provider].name}</h3>
          <p className="text-muted-foreground text-sm">{estimatedTime} min away</p>
        </div>
      </div>

      <div className="mt-4 mb-3">
        <p className="text-2xl font-bold">₹{price.toFixed(2)}</p>
      </div>

      <Button 
        onClick={onSelect}
        className={cn(
          "w-full", 
          isLowest ? "bg-brand-purple hover:bg-brand-purple-dark" : "bg-secondary text-foreground hover:bg-secondary/80"
        )}
      >
        {isLowest ? "Book Now" : "Select"}
      </Button>
    </div>
  );
};

export default RideCard;
