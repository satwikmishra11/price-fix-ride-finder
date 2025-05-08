
import React, { useState } from 'react';
import RideCard from './RideCard';
import { toast } from "@/components/ui/sonner";

export interface RideData {
  provider: "uber" | "ola" | "rapido";
  price: number;
  estimatedTime: number;
}

interface RideOptionsProps {
  rideData: RideData[];
}

const RideOptions = ({ rideData }: RideOptionsProps) => {
  // Sort rides by price (lowest first)
  const sortedRides = [...rideData].sort((a, b) => a.price - b.price);
  
  const [selectedRide, setSelectedRide] = useState<RideData | null>(null);
  
  const handleSelectRide = (ride: RideData) => {
    setSelectedRide(ride);
    toast.success(`${ride.provider.charAt(0).toUpperCase() + ride.provider.slice(1)} ride selected for ₹${ride.price.toFixed(2)}!`);
  };

  return (
    <div className="mt-6">
      <h2 className="text-lg font-semibold mb-3">Available Rides</h2>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        {sortedRides.map((ride, index) => (
          <div key={ride.provider} className="animate-fade-in" style={{ animationDelay: `${index * 150}ms` }}>
            <RideCard
              provider={ride.provider}
              price={ride.price}
              estimatedTime={ride.estimatedTime}
              isLowest={index === 0}
              onSelect={() => handleSelectRide(ride)}
            />
          </div>
        ))}
      </div>
    </div>
  );
};

export default RideOptions;
