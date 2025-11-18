
import React, { useState } from 'react';
import Header from '@/components/Header';
import LocationInput from '@/components/LocationInput';
import RideOptions from '@/components/RideOptions';
import { RideData } from '@/components/RideOptions';
import { getMockRideData } from '@/data/mockData';
import { calculateSavings } from '@/utils/priceComparison';

const Index = () => {
  const [rideData, setRideData] = useState<RideData[] | null>(null);
  const [searchInfo, setSearchInfo] = useState<{ pickup: string; dropoff: string } | null>(null);
  const [savings, setSavings] = useState<number | null>(null);

  const handleSearch = (pickup: string, dropoff: string) => {
    const mockData = getMockRideData(pickup, dropoff);
    setRideData(mockData);
    setSearchInfo({ pickup, dropoff });
    setSavings(calculateSavings(mockData));
  };

  return (
    <div className="min-h-screen bg-secondary/50 flex flex-col">
      <Header />
      <main className="flex-1 container py-6 px-4 max-w-5xl mx-auto">
        <h1 className="text-3xl font-bold text-center mb-2">Find Your Best Ride Deal</h1>
        <p className="text-center text-muted-foreground mb-8">Compare prices across Uber, Ola, and Rapido</p>
        
        <LocationInput onSearch={handleSearch} />
        
        {searchInfo && (
          <div className="mt-8 px-4">
            <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center bg-white p-4 rounded-lg shadow-sm">
              <div>
                <h2 className="font-medium">Route Details</h2>
                <p className="text-sm text-muted-foreground">
                  From: <span className="text-foreground">{searchInfo.pickup}</span>
                </p>
                <p className="text-sm text-muted-foreground">
                  To: <span className="text-foreground">{searchInfo.dropoff}</span>
                </p>
              </div>
              
              {savings !== null && savings > 0 && (
                <div className="mt-3 sm:mt-0 px-4 py-2 bg-green-50 text-green-700 rounded-md">
                  <p className="font-medium">Save up to ₹{savings.toFixed(2)}</p>
                </div>
              )}
            </div>
          </div>
        )}
        
        {rideData && <RideOptions rideData={rideData} />}
        
        {!rideData && !searchInfo && (
          <div className="mt-12 text-center">
            <div className="w-full max-w-md mx-auto p-6 bg-white rounded-lg shadow-sm">
              <svg 
                className="w-12 h-12 mx-auto text-brand-purple" 
                xmlns="http://www.w3.org/2000/svg" 
                width="24" 
                height="24" 
                viewBox="0 0 24 24" 
                fill="none" 
                stroke="currentColor" 
                strokeWidth="2" 
                strokeLinecap="round" 
                strokeLinejoin="round"
              >
                <path d="M12 2L2 7L12 12L22 7L12 2Z"></path>
                <path d="M2 17L12 22L22 17"></path>
                <path d="M2 12L12 17L22 12"></path>
              </svg>
              <h3 className="mt-4 text-lg font-medium">How It Works</h3>
              <p className="mt-2 text-muted-foreground text-sm">
                Enter your pickup and dropoff locations to compare prices across Uber, Ola, and Rapido.
                We'll help you find the most affordable ride option.
              </p>
            </div>
          </div>
        )}
      </main>
      
      <footer className="w-full py-6 bg-white border-t">
        <div className="container text-center text-sm text-muted-foreground">
          <p>© 2025 PriceFix - Find the cheapest rides instantly</p>
        </div>
      </footer>
    </div>
  );
};

export default Index;
